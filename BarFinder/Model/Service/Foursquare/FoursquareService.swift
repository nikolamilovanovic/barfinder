//
//  FoursquareService.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/15/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import CoreData
import Alamofire

final class FoursquareService: ServiceProtocol {
  
  private enum Constants {
    static let throttlingTime = 2.0
    static let retryPeriod = 120.0
    static let category = "Bar"
    static let maxRetries = 5
  }
  
  private let disposeBag: DisposeBag
  private let scheduler: SchedulerType
  
  private let api: FoursquareAPIProtocol
  private let apiCallSerializeSubject: PublishSubject<Observable<([Bar]?, Error?)>>
  
  private let errorsSubject: PublishSubject<ErrorData>
  private let fetchingStatusSubject: ReplaySubject<FetchingStatus>
  
  private let retrySubject: PublishSubject<Void>
  private var retryDisposable: Disposable?
  private var retryAttempt: Int
  
  private let coreDataController: CoreDataControllerProtocol
  
  private let moc: NSManagedObjectContext
  
  // we will preserve catogery Id once we have it, it doesn't make sense to search for it every time
  // we will keep it only during app lifetime
  private var categoryId: String?

  var type: ServiceType {
    return .foursquare
  }
  
  var requireLogIn: Bool {
    return false
  }
  
  init(api: FoursquareAPIProtocol = FoursquareAPI(), coreDataController: CoreDataControllerProtocol) {
    self.api = api
    self.apiCallSerializeSubject = PublishSubject()
    self.disposeBag = DisposeBag()
    self.scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "scheduler.serial.foursquare")
    self.errorsSubject = PublishSubject()
    self.retrySubject = PublishSubject()
    self.retryAttempt = 0
    self.fetchingStatusSubject = ReplaySubject.create(bufferSize: 1)
    self.coreDataController = coreDataController
    self.moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    moc.parent = coreDataController.persistentContainer.viewContext
  }
  
  var errors: Observable<ErrorData> {
    return errorsSubject
  }
  
  var fetchingStatus: Observable<FetchingStatus> {
    return fetchingStatusSubject
  }
  
  func start() {
    bindToObservables()
  }
  
  private func bindToObservables() {
    let location = App.current.locationService.getLocation()
    let searchingDistance = App.current.settings.searchingDistance
    
    /// Observable that contains latest values for locatin and searchingDistance, it should trigger downloading data for new bars
    let locationWithDistance = Observable.combineLatest(location, searchingDistance)
    
    /// Retrying making api request if error is accured during last attempt. It is limited to number of retrying as we don't want to have infinite loop of request and to spam server
    let triggerRetryWithLocationWithDistance = retrySubject.withLatestFrom(locationWithDistance)
      .do(onNext: { _ in
        self.retryAttempt += 1
      })
      .filter { _ in
        self.retryAttempt <= Constants.maxRetries
      }
    
    /// Trigger download when there was recahability change from .notReachable to .reachable(Wifi or celluar). Actualy this is not proper way to handling those events. Proper way would be to use rechability observable in trigger variable (defained in next code) with combineLatest, and then filter combined events to pass only events when network is reachable. This way we will prevent api request when there is no internet, and start request when internet is avaliable. The only reason I didn't do that is some problems with NetworkReachabilityManager (that i use for reachability) that i read on on internet especialy with Simulators. As I didn't have time to test that class to see what happens, I handled that changes this way, as proper way could lead to risk to don't trigger api request at all. Errors with no network will be handled approperly.
    let triggerReachability = App.current.reachabilityService.status
      .scan((ReachabilityStatus.unknown, false)) { prev, currentStatus in
        let previousStatus = prev.0
        
        var shouldTriggerFetch = false
        if previousStatus == .notReachable && (currentStatus == .reachableViaWiFi || currentStatus == .reachableViaWwaN) {
          shouldTriggerFetch = true
        }
        
        return (currentStatus, shouldTriggerFetch)
      }.filter { _, shouldTriggerFetch in
        return shouldTriggerFetch
      }.withLatestFrom(locationWithDistance)
    
    // trigger when location or distance is change, or when trigger for retry and reachability is generated
    let trigger = Observable.merge(locationWithDistance, triggerRetryWithLocationWithDistance, triggerReachability)
    
    // on trigger start downloading bars
    trigger
      .subscribeOnNext { [unowned self] (location, searchingDistance) in
        self.downloadBars(location: location, searchingDistance: Int(searchingDistance))
    }.disposed(by: disposeBag)
    
    // this is used for serealizing api request. With this logic and by using concatMap we will not start new request chain before previous is completed
    apiCallSerializeSubject.concatMap { observable  in
        return observable
      }.observeOn(scheduler)
      .subscribeOnNext { [unowned self] bars, error in
        if let bars = bars {
          self.handleNewBars(bars)
        } else if let error = error {
          self.handleApiError(error)
        }
      }.disposed(by: disposeBag)
  }
  
  private func downloadBars(location: CLLocation, searchingDistance: Int) {
    // disposing retry
    retryDisposable?.dispose()
    retryDisposable = nil
    
    let apiCall = getBarsCategoryId()
        // first get category id
      .filter { (catogoryId) -> Bool in
        // process only if categoryId is not nil
        return catogoryId != nil
      }.do(onNext: { [unowned self] _ in
        // fetching new objects is started, inform subscibers about that
        self.setFetchingStatus(to: .started)
      }).map {
        $0! // at this point categoryId is not nil, unwrapp it
      }.flatMap { [unowned self] categoryId in
        // get all bars for seraching criterium
        self.getBars(categoryId: categoryId, location: location, searchingDistance: searchingDistance)
      }.flatMap { [unowned self] bars in
        // we will try to download data only for bars that we don't have in core data to reduce network request
        // it could make sense to preserve date when bar detail is downladed, and then when some time is passed, download again just to have fresh data
        self.filterBarsThatAreNotSaved(from: bars)
      }.flatMap { newBars in
        // transfer array of bars to new observable
        return Observable.from(newBars)
      }.flatMap { [unowned self] bar in
        // for every bar get details, including bestPhoto
        self.getDetails(for: bar)
      }.reduce([]) { prev, newBar in
        // wait while all bars downloading is finised, than process
        return prev + [newBar]
      }.map { newBars -> ([Bar]?, Error?) in
        // if observable finish with success generate appropiate tuple
        return (newBars, nil)
      }.catchError { (error) -> Observable<([Bar]?, Error?)> in
        // if error is catched generated appropiate tuple. This was done as we don't want error in apiCallSerializeSubject. Error will kill apiCallSerializeSubject and we would not be able to make any new api request. Because of that there is this logic for packing error and downloaded bars in tuples.
        return Observable.just((nil, error))
      }
    
    apiCallSerializeSubject.onNext(apiCall)
  }
  
  /// Inform subscribers about new status change
  private func setFetchingStatus(to status: FetchingStatus) {
    DispatchQueue.main.async { // event for this subject must be sent from main thread
      self.fetchingStatusSubject.onNext(status)
    }
  }
  
  /// Called when new bars are downloaded
  private func handleNewBars(_ bars: [Bar]) {
    DispatchQueue.main.async {
      // if it is success, reset retryAttempt
      self.retryAttempt = 0
    }
    
    guard bars.count > 0 else {
      // prevent work if bars list is empty
      setFetchingStatus(to: .finished)
      return
    }
    
    moc.perform {
      let request: NSFetchRequest<BarMO> = BarMO.fetchRequest()
      do {
        // creating bar dictionary for performance
        let newBarsTuples = bars.map { ($0.id, $0) }
        let newBarsDict = Dictionary(uniqueKeysWithValues: newBarsTuples)
        
        // checking again, just in case to not duplicate objects in Core Data
        let fetchedBars = try self.moc.fetch(request)
        let coreDataObjectIds = fetchedBars.map { $0.id! }
        let newBarIds = self.elementFrom(array: Array(newBarsDict.keys), notContainedIn: coreDataObjectIds)
        
        try newBarIds.forEach { barId in
          let bar = newBarsDict[barId]!
          let barMO = BarMO(context: self.moc)
          barMO.id = bar.id
          barMO.name = bar.name
          barMO.lat = bar.lat
          barMO.long = bar.long
          barMO.distance = Int64(bar.distance ?? 0)
          barMO.descr = bar.description
          barMO.url = bar.url
          barMO.phone = bar.phone
          barMO.twitter = bar.twitter
          barMO.instagram = bar.instagram
          barMO.facebookUsername = bar.facebookUsername
          barMO.address = bar.address
          barMO.postalCode = bar.postalCode
          barMO.city = bar.city
          barMO.country = bar.country
          barMO.formattedAddress = bar.formattedAddressAsString
          
          if let bestPhoto = bar.bestPhoto {
            let imageHolder = ImageHolderMO(context: self.moc)
            imageHolder.image = bestPhoto
            barMO.bestPhoto = imageHolder
          }
          
          // saving one by one, as saving all together can make problem to FetchResultController delegate, as it informs that one object is changed but more is changed. That can cause crash in TableViewController
          if self.moc.hasChanges {
            try self.moc.save()
          }
        }
        
        // after all objects are added, save it
        self.moc.parent?.perform {
          do {
            try self.moc.parent?.save()
          } catch {
            print("Error saving core data objects: error")
          }
        }
        
        // inform subscibers that new object are fetched
        self.setFetchingStatus(to: .finishedWithNewObjects)
      } catch {
        print("Error fetching Bars. Error: \(error)")
      }
    }
  }

  // handling api errors
  private func handleApiError(_ error: Error) {
    DispatchQueue.main.async {
      self.setFetchingStatus(to: .finished)

      guard let error = error as? AFError else { return } // all errors must be AFError
      guard self.shouldHandleError(error) else { return }
      
      // creating retrying trigger
      self.retryDisposable?.dispose()
      self.retryDisposable = MainScheduler.instance.scheduleRelative((), dueTime: Constants.retryPeriod) { _ in
        self.retrySubject.onNext(())
        return Disposables.create()
      }
      
      if self.shouldInformAboutError(error) {
        self.errorsSubject.onNext(ErrorData(error: error, title: LocalizedStrings.Common.error, message: error.localizedDescription))
      }
    }
  }
  
  private func shouldHandleError(_ error: AFError) -> Bool {
    guard let code = error.responseCode else {
      return true
    }
    
    // if we made bad request, there is no need for retrying or any other handling
    return code != 400
  }
  
  private func shouldInformAboutError(_ error: AFError) -> Bool {
    guard let code = error.responseCode else {
      return true
    }
    
    // if it is client error, don't inform, it could be auth problem or too much queries
    return code/100 != 4
  }
  
  private func getBarsCategoryId() ->Observable<String?> {
    // if we alredy have categoryId, just send it
    if let categoryId = categoryId {
      return Observable.just(categoryId)
    }
    
    // get category from api and saving it. Handling response on main thread, as we use main thread for getting an setting categoryId property
    return api.getCategories(queue: .main)
      .map { [unowned self] categoryResponse in
        return self.getCategoryId(from: categoryResponse.response.categories)
      }.do(onSuccess: { categoryId in
        // save category id for next api request
        self.categoryId = categoryId
      }).asObservable()
  }
  
  private func getCategoryId(from categories: [CategoryFSAPI]) -> String? {
    for category in categories {
      if category.name == Constants.category {
        return category.id
      }
      
      if let categoryId = getCategoryId(from: category.categories) {
        return categoryId
      }
    }
    
    return nil
  }
  
  /// get bars using fourscaqure api
  private func getBars(categoryId: String, location: CLLocation, searchingDistance: Int) -> Observable<[Bar]> {
    return api.getVenues(categoryId: categoryId, location: location, radius: searchingDistance, queue: .background)
      .asObservable()
      .map { [unowned self] venuesResponse in
        return venuesResponse.response.venues.map(self.convertVenueToBar)
    }
  }
  
  private func getDetails(for bar: Bar) -> Observable<Bar> {
    return api.getVenueDetail(id: bar.id, queue: .background)
      .asObservable()
      .map { [unowned self] venueResponse in
        return self.convertVenueToBar(venue: venueResponse.response.venue)
      }.flatMap { [unowned self] barWithDetail in
        // add best photo
        return self.addBestPhoto(to: barWithDetail)
      }.map { barWithDetail in
        return barWithDetail
          // add distance to bar object as venues fethed with search has distance value, and the objects fetched with detail don't have it
          |> Bar.lens.distance %~ { $0 ?? bar.distance }
      }.asObservable()
      // prevent generating error if photo or detail api fails, just return previous bar in that case
      .catchErrorJustReturn(bar)
  }
  
  private func filterBarsThatAreNotSaved(from bars: [Bar]) -> Observable<[Bar]> {
    return Observable.create { (observer) -> Disposable in
      self.moc.perform { [unowned self] in
        let request: NSFetchRequest<BarMO> = BarMO.fetchRequest()
        do {
          // creating bar dictionary for performance
          let newBarsTuples = bars.map { ($0.id, $0) }
          let newBarsDict = Dictionary(uniqueKeysWithValues: newBarsTuples)
          
          let fetchedBars = try self.moc.fetch(request)
          let coreDataObjectIds = fetchedBars.map { $0.id! }
          let outputBarIds = self.elementFrom(array: Array(newBarsDict.keys), notContainedIn: coreDataObjectIds)
          
          let output = outputBarIds.map { newBarsDict[$0]! }
          
          observer.onNext(output)
          observer.onCompleted()
        } catch {
          print("Error fetching Bars. Error: \(error)")
          observer.onError(error)
        }
      }
      
      return Disposables.create()
    }
  }
  
  private func convertVenueToBar(venue: VenueFSAPI) -> Bar {
    return Bar(id: venue.id,
               name: venue.name,
               lat: venue.location.lat,
               long: venue.location.lng,
               distance: venue.location.distance,
               url: venue.url,
               description: venue.description,
               bestPhotoPrefix: venue.bestPhoto?.prefix,
               bestPhotoSuffix: venue.bestPhoto?.suffix,
               bestPhoto: nil,
               phone: venue.contact?.formattedPhone ?? venue.contact?.phone,
               twitter: venue.contact?.twitter,
               instagram: venue.contact?.instagram,
               facebookUsername: venue.contact?.facebookUsername ?? venue.contact?.facebookName,
               address: venue.location.address,
               postalCode: venue.location.postalCode,
               city: venue.location.city,
               state: venue.location.state,
               country: venue.location.country,
               formattedAddress: venue.location.formattedAddress)
  }
  
  private func addBestPhoto(to bar: Bar) -> Single<Bar> {
    guard let photoPrefix = bar.bestPhotoPrefix, let photoSuffix = bar.bestPhotoSuffix else {
      // if some needed data is missing just return bar with no best photo
      return Single.just(bar)
    }
    
    return api.getImageFor(prefix: photoPrefix, suffix: photoSuffix, queue: .background)
      .map { image in
        return bar
          |> Bar.lens.bestPhoto .~ image
          |> Bar.lens.distance %~ { $0.map { $0 * 10 } }
      }
  }
  
  private func elementFrom<Element: Hashable>(array: [Element], notContainedIn other: [Element]) -> [Element] {
    let otherSet = Set<Element>(other)
    
    let output =  array.filter { !otherSet.contains($0) }

    return output
  }
}
