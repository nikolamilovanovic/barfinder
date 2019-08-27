//
//  SettingCellViewModel.swift
//
//  Created by Nikola Milovanovic on 4/23/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// protocol for settings cell view models. As they can be of different type (bool with switch for example), this enables is to creating right cells for view models.

enum SettingCellType {
  case double
}

enum SettingCellId {
  case searchingDistance
}

protocol SettingCellViewModelProtocol {
  var type: SettingCellType { get }
}
