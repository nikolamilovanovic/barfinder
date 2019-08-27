//
//  App.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift

/// Model of the application. It is singleton that contains all services and methods needed by Model and View Model layer. It should not be called from View layer. It should not use any UIKit objects. All methods should be called from main thread, as this object is not thread safe

typealias OpeninigAppURLHandler = (UIApplication, URL, [UIApplicationOpenURLOptionsKey : Any]) -> Bool
typealias OpeninigURLHandler = (URL) -> Void

final class App {
  
  static let current = App()
  
  private var openingAppURLHandler: OpeninigAppURLHandler?
  private var openingURLHandler: OpeninigURLHandler?
  
  private var appLaunchingBlock: (() -> Void)?
  private var viewLaunchingBlock: (() -> Void)?
  
  private let errorsSubject: PublishSubject<ErrorData>
  
  // private objects
  private var coreDataControllerHolder: ObjectLazyHolder<CoreDataControllerProtocol>!
  private var distanceSynchronizerHolder: ObjectLazyHolder<DistanceSynchronizerProtocol>!
  
  // public objects
  private var barsDataControllerHolder: ObjectLazyHolder<BarsDataControllerProtocol>!
  private var serviceHolder: ObjectLazyHolder<ServiceProtocol>!
  private var locationServiceHolder: ObjectLazyHolder<LocationServiceProtocol>!
  private var settingsHolder: ObjectLazyHolder<SettingsProtocol>!
  private var reachabilityServiceHolder: ObjectLazyHolder<ReachabilityServiceProtocol>!

  private init() {
    self.errorsSubject = PublishSubject()
    self.coreDataControllerHolder = ObjectLazyHolder(creator: CoreDataController(name: "BarFinder"))
    self.distanceSynchronizerHolder = ObjectLazyHolder(creator: DistanceSynchronizer())
    self.barsDataControllerHolder = ObjectLazyHolder(creator: { [unowned self] in
      return BarsDataController(coreDataController: self.coreDataController)
    })
    self.serviceHolder = ObjectLazyHolder(creator: { [unowned self] in
      return FoursquareService(coreDataController: self.coreDataController)
    })
    self.locationServiceHolder = ObjectLazyHolder(creator: LocationService())
    self.settingsHolder = ObjectLazyHolder(creator: Settings())
    self.reachabilityServiceHolder = ObjectLazyHolder(creator: ReachabilityService())
    
    self.appLaunchingBlock = {
      // on app launch start services that need to be started in that moment
      self.reachabilityService.start()
      self.service.start()
    }
    
    self.viewLaunchingBlock = {
      // connect error observables
      let errorObservables: [Observable<ErrorData>] = [App.current.service.errors, App.current.locationService.errors]
      _ = Observable.merge(errorObservables).bind(to: self.errorsSubject)
      
      // on view open start services that need to be started in that moment
      self.locationService.start()
      self.distanceSynchronizer.start()
    }
  }
  
  /// All errors combined from services
  var errors: Observable<ErrorData> {
    return errorsSubject
  }
  
  /// This should be called when application is launched. It will make side affect only on first call
  func applicationIsLaunched() {
    if let launchingBlock = appLaunchingBlock {
      launchingBlock()
      appLaunchingBlock = nil
    }
  }
  
  /// This should be called when view is launched. It will make side affect only on first call
  func viewIsLaunched() {
    if let launchingBlock = viewLaunchingBlock {
      launchingBlock()
      viewLaunchingBlock = nil
    }
  }
  
  // Registering open url handler. It should be called from AppDelegate via AppDelegateViewModel as it opening url uses UIApplication, that is part of UIKit and should not be part of model
  func registerOpenURLHandler(handler: @escaping OpeninigURLHandler) {
    self.openingURLHandler = handler
  }
  
  // Opening url
  func open(url: URL) {
    if let openingHandler = self.openingURLHandler {
      openingHandler(url)
    }
  }
  
  // Registering applicatin opening url handler that called in AppDelegate. This was used for enabling Twitter API. Twitter service called this method
  func registerOpenAppURLHandler(handler: @escaping OpeninigAppURLHandler) {
    self.openingAppURLHandler = handler
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if let openingHandler = self.openingAppURLHandler {
      return openingHandler(app, url, options)
    }
    
    return false
  }
  
  // private objects
  private var coreDataController: CoreDataControllerProtocol {
    return coreDataControllerHolder.getValue()
  }
  
  private var distanceSynchronizer: DistanceSynchronizerProtocol {
    return distanceSynchronizerHolder.getValue()
  }
  
  // public objects
  var barsDataController: BarsDataControllerProtocol {
    return barsDataControllerHolder.getValue()
  }
  
  func push(barsDataController: BarsDataControllerProtocol) {
    barsDataControllerHolder.push(barsDataController)
  }
  
  func popBarsDataController() {
    barsDataControllerHolder.pop()
  }
  
  var service: ServiceProtocol {
    return serviceHolder.getValue()
  }
  
  func push(service: ServiceProtocol) {
    serviceHolder.push(service)
  }
  
  func popService() {
    serviceHolder.pop()
  }
  
  var locationService: LocationServiceProtocol {
    return locationServiceHolder.getValue()
  }
  
  func push(locationService: LocationServiceProtocol) {
    locationServiceHolder.push(locationService)
  }
  
  func popLocationService() {
    locationServiceHolder.pop()
  }
  
  var settings: SettingsProtocol {
    return settingsHolder.getValue()
  }
  
  func push(settings: SettingsProtocol) {
    settingsHolder.push(settings)
  }
  
  func popSettings() {
    settingsHolder.pop()
  }
  
  var reachabilityService: ReachabilityServiceProtocol {
    return reachabilityServiceHolder.getValue()
  }
  
  func push(reachability: ReachabilityServiceProtocol) {
    reachabilityServiceHolder.push(reachability)
  }
  
  func popReachability() {
    reachabilityServiceHolder.pop()
  }
}
