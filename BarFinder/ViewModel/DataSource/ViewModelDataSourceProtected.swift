//
//  ViewModelDataSourceProtected.swift
//  
//
//  Created by Nikola Milovanovic on 4/24/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

// Base class that includes some helper methods and subjects.
class ViewModelDataSourceProtected<CellViewModel>: ViewModelDataSource<CellViewModel> {
  
  let changeSubject: PublishSubject<DataSourceChangeType>
  let shouldInformSubject: BehaviorSubject<Bool>

  override init() {
    self.changeSubject = PublishSubject()
    self.shouldInformSubject = BehaviorSubject(value: true)
    super.init()
  }
  
  func stopInformingSubscribers() {
    shouldInformSubject.onNext(false)
  }
  
  func startInformingSubscribers() {
    shouldInformSubject.onNext(true)
  }
  
  // preventing changes if we want to stop dataSouce to inform about changes
  override var changeObservable: Observable<DataSourceChangeType> {
    return changeSubject
      .withLatestFrom(shouldInformSubject) { (changeType, shouldInform) -> (DataSourceChangeType, Bool) in
        return (changeType, shouldInform)
      }.filter {
        $0.1
      }.map {
        $0.0
    }
  }
}
