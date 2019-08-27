//
//  MainViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MainScreenAlertId: Equatable {
  case error
}

protocol MainViewModelInputs: AppViewModelInputs {
  func viewDidAppear()
}

protocol MainViewModelOutputs: AppViewModelOutputs {
  var tabScenes: [TabBarSceneData] { get }
  var selectedIndexOnStart: Int { get }
  var showAlert: Observable<AlertData<MainScreenAlertId>> { get }
}

protocol MainViewModelProtocol {
  var inputs: MainViewModelInputs { get }
  var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: AppViewModel, MainViewModelProtocol, MainViewModelInputs, MainViewModelOutputs {
  
  private let showAlertSubject: ReplaySubject<AlertData<MainScreenAlertId>>
  private var openingViewSubject: PublishSubject<Void>?
  
  var inputs: MainViewModelInputs {
    return self
  }
  
  var outputs: MainViewModelOutputs {
    return self
  }
  
  private(set) var tabScenes: [TabBarSceneData]
  private(set) var selectedIndexOnStart: Int
  
  override init() {
    self.showAlertSubject = ReplaySubject.create(bufferSize: 1)
    
    // creating tab scenes
    self.tabScenes = [
      TabBarSceneData(scene: .list(ListViewModel()), title: LocalizedStrings.ListScreen.title),
      TabBarSceneData(scene: .map(MapViewModel()), title: LocalizedStrings.MapScreen.title),
      TabBarSceneData(scene: .settings(SettingsViewModel()), title: LocalizedStrings.SettingsScreen.title)
    ]
    
    // add service screen only if service require logIn. It will be included for Twitter but not for Foursqaure
    if App.current.service.requireLogIn {
      let serviceTabBarScene = TabBarSceneData(scene: .service(ServiceViewModel()), title: App.current.service.type.localizedName)
      self.tabScenes.insert(serviceTabBarScene, at: 0)
    }
    
    self.selectedIndexOnStart = 0
    
    super.init()
    
    bindToObservables()
  }
  
  var showAlert: Observable<AlertData<MainScreenAlertId>> {
    return showAlertSubject
  }
  
  private func bindToObservables() {
    /// send errors to viewController as alerts
    App.current.errors
      .map { errorData in
        AlertData.infoDataWith(id: MainScreenAlertId.error,
                               title: errorData.title,
                               message: errorData.message)
      }.bind(to: self.showAlertSubject)
      .disposed(by: self.disposeBag)
    
    /// calls App vieIsLaunched only when viewDidLoad is called for first time
    viewStatusSubject
      .filter { $0 }
      .take(1) // it will complete after first events
      .subscribeOnNext { (_) in
        App.current.viewIsLaunched()
      }.disposed(by: disposeBag)
  }
}
