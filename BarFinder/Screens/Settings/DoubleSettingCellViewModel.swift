//
//  DoubleCellViewModel.swift
//
//  Created by Nikola Milovanovic on 4/22/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DoubleSettingCellViewModelInputs {
  func valueChanged(to newValue: Double)
}

protocol DoubleSettingCellViewModelOutputs {
  var value: BehaviorRelay<Double> { get }
  var title: String { get }
  var diffValue: Double { get }
  var minValue: Double? { get }
  var maxValue: Double? { get }
}

protocol DoubleSettingCellViewModelProtocol {
  var inputs: DoubleSettingCellViewModelInputs { get }
  var outputs: DoubleSettingCellViewModelOutputs { get }
}

final class DoubleSettingCellViewModel: DoubleSettingCellViewModelProtocol, DoubleSettingCellViewModelInputs, DoubleSettingCellViewModelOutputs {
  
  typealias DoubleCellChangeHandler = (Double) -> Void
  
  private let id: Any
  private let changeHandler: DoubleCellChangeHandler
  
  let value: BehaviorRelay<Double>
  let title: String
  
  let diffValue: Double
  let minValue: Double?
  let maxValue: Double?
  
  var inputs: DoubleSettingCellViewModelInputs {
    return self
  }
  
  var outputs: DoubleSettingCellViewModelOutputs {
    return self
  }
  
  init(id: Any, value: Double, diffValue: Double, minValue: Double?, maxValue: Double?, title: String, changeHandler: @escaping DoubleCellChangeHandler) {
    self.id = id
    self.value = BehaviorRelay(value: value)
    self.diffValue = diffValue
    self.minValue = minValue
    self.maxValue = maxValue
    self.title = title
    self.changeHandler = changeHandler
  }
  
  // handling value change
  func valueChanged(to newValue: Double) {
    guard value.value != newValue else { return }
    
    var convertedNewValue = newValue
    
    if let minValue = minValue {
      convertedNewValue = max(convertedNewValue, minValue)
    }
    
    if let maxValue = maxValue {
      convertedNewValue = min(convertedNewValue, maxValue)
    }
    
    guard value.value != convertedNewValue else { return }
    
    value.accept(convertedNewValue)
    changeHandler(convertedNewValue)
  }
}

extension DoubleSettingCellViewModel: SettingCellViewModelProtocol {
  var type: SettingCellType {
    return .double
  }
}
