//
//  MVVMBindable.swift
//  SwiftStarter
//
//  Created by Nikola Milovanovic on 12/14/17.
//  Copyright © 2017 Nikola Milovanovic. All rights reserved.
//

import Foundation
import UIKit

/// Bindable type is used in MVVM for binding viewModel to viewController. All viewController used in application must confirm to this protocol

protocol BindableType {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType! { get set }
  
  func bindViewModel()
}

extension BindableType where Self: UIViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    self.viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
}

