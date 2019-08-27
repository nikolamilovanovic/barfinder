//
//  Settings.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Setting object is used processing all data related to user settings that are (or not) visibale on settings screen. It preserves that data and informs all subsciber about data change

protocol SettingsProtocol {
  var maxDistance: Double { get }
  var minDistance: Double { get }
  var diffValue: Double { get }
  var searchingDistance: Observable<Double> { get }

  func changeSearchingDistance(to searchingDistance: Double)
}

final class Settings: SettingsProtocol {
  
  private enum Constants {
    static let userDefaultsKey = "kSettings"
    static let maxDistance = 5000.0
    static let minDistance = 300.0
    static let diffValue = 100.0
    static let debounceTime = 1.0
  }
  
  private let disposeBag: DisposeBag
  private let userDefaultsCodableProvider: UserDefaultsCodableProvider
  
  var maxDistance: Double {
    return Constants.maxDistance
  }
  
  var minDistance: Double {
    return Constants.minDistance
  }
  
  var diffValue: Double {
    return Constants.diffValue
  }
  
  var _searchingDistance: BehaviorSubject<Double>!
  var searchingDistance: Observable<Double> {
    return _searchingDistance
  }
  
  private let searchingDistanceChangeSubject: PublishSubject<Double>
  
  init() {
    self.disposeBag = DisposeBag()
    self.userDefaultsCodableProvider = UserDefaultsCodableProvider()
    self.searchingDistanceChangeSubject = PublishSubject()
    let searchDistance = loadSearchingDistance()
    self._searchingDistance = BehaviorSubject(value: searchDistance)
    bindToObservables()
  }
  
  private func bindToObservables() {
    searchingDistanceChangeSubject
      // doubuncing signal. This is used because in setting screen user can tap stepper fast and to trigger changes. With using debouce we will wait some time after user finished tapping and then react.
      .debounce(Constants.debounceTime, scheduler: MainScheduler.instance)
      .filter { (newValue) -> Bool in
        // accept only valid values
        return newValue >= Constants.minDistance && newValue <= Constants.maxDistance
      }.do(onNext: { newValue in
        // on next event save current setting, before informing subscribers
        let settingsData = SettingsData(searchingDistanceInMeters: newValue)
        self.userDefaultsCodableProvider.save(object: settingsData, for: Constants.userDefaultsKey)
      }).bind(to: _searchingDistance)
      .disposed(by: disposeBag)
  }
  
  /// loading setting from userDefautls. should be called only on initialization
  private func loadSearchingDistance() -> Double {
    if let settingsData: SettingsData = userDefaultsCodableProvider.loadData(for: Constants.userDefaultsKey) {
      return settingsData.searchingDistanceInMeters
    } else {
      let settingData = defaultSettingsData
      userDefaultsCodableProvider.save(object: settingData, for: Constants.userDefaultsKey)
      return settingData.searchingDistanceInMeters
    }
  }
  
  func changeSearchingDistance(to searchingDistance: Double) {
    searchingDistanceChangeSubject.onNext(searchingDistance)
  }
  
  // default settings values. Used when there are no setting in userDefauls.
  private var defaultSettingsData: SettingsData {
    return SettingsData(searchingDistanceInMeters: 1000)
  }
}
