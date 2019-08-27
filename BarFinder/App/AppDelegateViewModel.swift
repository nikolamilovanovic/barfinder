//
//  AppViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/15/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppDelegateViewModelInputs {
  func applicationDidFinishLaunchingWithOptions(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
  func applicationWillResignActive()
  func applicationDidEnterBackground()
  func applicationWillEnterForeground()
  func applicationDidBecomeActive()
  func applicationWillTerminate()
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
  
  func registerOpenURL(_ handler: @escaping (URL) -> Void)
}

protocol AppDelegateViewModelOutputs {
  var initialScene: Scene { get }
  var fetchingStatus: Observable<Bool> { get }
}

protocol AppDelegateViewModelProtocol {
  var inputs: AppDelegateViewModelInputs { get }
  var outputs: AppDelegateViewModelOutputs { get }
}

final class AppDelegateViewModel: AppDelegateViewModelProtocol, AppDelegateViewModelInputs, AppDelegateViewModelOutputs {

  private let disposeBag: DisposeBag
  
  var inputs: AppDelegateViewModelInputs {
    return self
  }
  
  var outputs: AppDelegateViewModelOutputs {
    return self
  }
  
  let initialScene: Scene
  
  init() {
    self.disposeBag = DisposeBag()
    self.initialScene = .main(MainViewModel())
  }
  
  func applicationDidFinishLaunchingWithOptions(_ launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    App.current.applicationIsLaunched()
    return true
  }
  
  func applicationWillResignActive() {
  }
  
  func applicationDidEnterBackground() {
  }
  
  func applicationWillEnterForeground() {
  }
  
  func applicationDidBecomeActive() {
  }
  
  func applicationWillTerminate() {
    // save core data on terminating
    App.current.barsDataController.saveChanges()
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    return App.current.application(app, open: url, options: options)
  }
  
  func registerOpenURL(_ handler: @escaping (URL) -> Void) {
    App.current.registerOpenURLHandler(handler: handler)
  }
  
  var fetchingStatus: Observable<Bool> {
    return App.current.service.fetchingStatus.map { status in
      switch status {
      case .started:
        return true
      case .finished, .finishedWithNewObjects:
        return false
      }
    }
  }
}
