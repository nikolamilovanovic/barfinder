//
//  AppDelegate.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/11/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let viewModel: AppDelegateViewModelProtocol = AppDelegateViewModel()
  
  let disposeBag = DisposeBag()

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {    
    bindToViewModel()
    
    return viewModel.inputs.applicationDidFinishLaunchingWithOptions(launchOptions)
  }
  
  private func bindToViewModel() {
    viewModel.inputs.registerOpenURL { url in
      return UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    let initialScene = viewModel.outputs.initialScene
    let vc = initialScene.createViewController()
    
    self.window?.rootViewController = vc
    self.window?.makeKeyAndVisible()
    
    viewModel.outputs.fetchingStatus.subscribeOnNext { (status) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = status
    }.disposed(by: disposeBag)
  }

  func applicationWillResignActive(_ application: UIApplication) {
    viewModel.inputs.applicationWillResignActive()
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    viewModel.inputs.applicationDidEnterBackground()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    viewModel.inputs.applicationWillEnterForeground()
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    viewModel.inputs.applicationDidBecomeActive()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    viewModel.inputs.applicationWillTerminate()
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return viewModel.inputs.application(app, open: url, options: options)
  }
}

