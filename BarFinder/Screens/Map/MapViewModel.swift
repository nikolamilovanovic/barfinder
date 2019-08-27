//
//  MapViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import CoreData

protocol MapViewModelInputs: AppViewModelInputs {
}

protocol MapViewModelOutputs: AppViewModelOutputs {
  var mapPosition: Observable<MapPosition> { get }
  var annotations: Observable<(removed: [BarAnnotation], added: [BarAnnotation])> { get }
}

protocol MapViewModelProtocol {
  var inputs: MapViewModelInputs { get }
  var outputs: MapViewModelOutputs { get }
}

final class MapViewModel: AppViewModel, MapViewModelProtocol, MapViewModelInputs, MapViewModelOutputs {
  
  enum Constants {
    static let searchingDistanceRatio = 5.0 // For how much bigger region we should load annotations
    static let minimumChangeLocation = 500.0
  }
  
  private let mapPositionSubject: ReplaySubject<MapPosition>
  private let newBarsSubject: PublishSubject<[BarMO]>
  private let annotationsSubject: ReplaySubject<(removed: [BarAnnotation], added: [BarAnnotation])>
  
  var inputs: MapViewModelInputs {
    return self
  }
  
  var outputs: MapViewModelOutputs {
    return self
  }
  
  override init() {
    self.mapPositionSubject = ReplaySubject.create(bufferSize: 1)
    self.annotationsSubject = ReplaySubject.create(bufferSize: 1)
    
    self.newBarsSubject = PublishSubject()
    
    super.init()
        
    bindToObservables()
  }
  
  var mapPosition: Observable<MapPosition> {
    return mapPositionSubject
  }
  
  var annotations: Observable<(removed: [BarAnnotation], added: [BarAnnotation])> {
    return annotationsSubject
  }
  
  private func bindToObservables() {
    // we are using larger location region for updating map region and to adding annotations to mapView
    // it make sense as mapView can be zoomed and there would be nice to include bars that are even not in search radius, but in larger area
    let location = App.current.locationService.getLocation(minimumDistanceChange: Constants.minimumChangeLocation)
    let distance = App.current.settings.searchingDistance
    
    // Obeservable that will send event when service fetched new objects, that should be trigger for fetching new objects from core data
    let fetchedNewObjects = App.current.service.fetchingStatus
      .filter { $0 == .finishedWithNewObjects }
    
    // Observable that will send only one event when view is first time opened and than completes
    let viewFirstOpen = viewStatusSubject
      .filter { $0 }
      .take(1)
    
    // Logic for updating map position on location and distance change
    Observable.combineLatest(location, distance, viewFirstOpen)
      .map {
        MapPosition(currentLocation: $0.0, radius: $0.1)
      }.bind(to: mapPositionSubject)
      .disposed(by: disposeBag)
    
    // trigger for fetching, on location or distance change and when new objects are added to core data
    let fetchTriggerlocationAndDistance = Observable.combineLatest(location, distance)
    let fetchTriggerNewObjects = fetchedNewObjects.withLatestFrom(fetchTriggerlocationAndDistance)
    let fetchTrigger = Observable.merge(fetchTriggerlocationAndDistance, fetchTriggerNewObjects)
    
    // logic for fetching new objects whem trigger arrives and when view is first time oppened
    Observable.combineLatest(fetchTrigger, viewFirstOpen)
      .subscribeOnNext { [unowned self] (location_distance, _) in
        let location = location_distance.0
        let distance = location_distance.1
        let bars = App.current.barsDataController.getBars(currentLocation: location, maxDistance: distance * Constants.searchingDistanceRatio)
        self.newBarsSubject.onNext(bars)
      }.disposed(by: disposeBag)
    
    // logic for creating annotatinos when new bars is fetched. It will send event to remove all previous annotations and add new ones as that is very fast achived by mapView
    newBarsSubject
      .scan(([BarAnnotation](), [BarAnnotation]())) { previous, newBars in
        let newAnnotations = newBars.map(BarAnnotation.init)
        let previousAnnotations = previous.1
        return (previousAnnotations, newAnnotations)
      }.bind(to: annotationsSubject)
      .disposed(by: disposeBag)
  }
}
