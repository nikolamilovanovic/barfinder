//
//  ObesrvableExtension.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift

/// Helper method for Observable types

extension ObservableType {
  
  func subscribeOnNext(_ block: @escaping (E) -> Void) -> Disposable {
    return subscribe(onNext: block, onError: nil, onCompleted: nil, onDisposed: nil)
  }
  
  func subscribeOnError(_ block: @escaping (Error) -> Void) -> Disposable {
    return subscribe(onNext: nil, onError: block, onCompleted: nil, onDisposed: nil)
  }
  
  func subscribeOnCompleted(_ block: @escaping () -> Void) -> Disposable {
    return subscribe(onNext: nil, onError: nil, onCompleted: block, onDisposed: nil)
  }
  
  func subscribeOnDisposed(_ block: @escaping () -> Void) -> Disposable {
    return subscribe(onNext: nil, onError: nil, onCompleted: nil, onDisposed: block)
  }
  
  func observeOnMainThread() -> Observable<E> {
    return self.observeOn(MainScheduler.instance)
  }
}

extension PrimitiveSequence {
  func observeOnMainThread() -> PrimitiveSequence<Trait,Element> {
    return self.observeOn(MainScheduler.instance)
  }
}
