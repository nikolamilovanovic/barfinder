//
//  DistanceSynchornizer.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/17/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift

/// Distance synchronzer is used for updating BarMO objects with current distance

protocol DistanceSynchronizerProtocol {
  func start()
}

final class DistanceSynchronizer: DistanceSynchronizerProtocol {
  
  private enum Constants {
    static let distanceChange = 10.0
  }
  
  let disposeBag: DisposeBag
  
  init() {
    self.disposeBag = DisposeBag()
  }
  
  func start() {
    // using small locaation change
    let location = App.current.locationService.getLocation(minimumDistanceChange: Constants.distanceChange)
    
    // on every location change update Bars
    location.subscribeOnNext { (location) in
      App.current.barsDataController.updateBars(for: location)
    }.disposed(by: disposeBag)
  }
}
