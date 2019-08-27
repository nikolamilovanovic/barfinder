//
//  AppViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/17/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Default AppViewModel. It implements some basic methods that can be used by all view models. It is recommeded that all view models subsclasses this class. 

protocol AppViewModelInputs {
  func viewDidAppear()
  func viewDidDisappear()
}

protocol AppViewModelOutputs {
}

open class AppViewModel: AppViewModelInputs, AppViewModelOutputs {
  
  let disposeBag: DisposeBag
  let viewStatusSubject: PublishSubject<Bool>
    
  init() {
    self.disposeBag = DisposeBag()
    self.viewStatusSubject = PublishSubject()
  }
  
  func viewDidAppear() {
    viewStatusSubject.onNext(true)
  }
  
  func viewDidDisappear() {
    viewStatusSubject.onNext(false)
  }
}
