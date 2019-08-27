//
//  DataSourceChangeType.swift
//  
//
//  Created by Nikola Milovanovic on 4/16/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// Change types for view model data sources

enum DataSourceElementChangeType {
  case insert
  case delete
  case move
  case update
}

enum DataSourceChangeType {
  case dataUpdated
  case contentWillChange
  case contentDidChange
  case objectChange(IndexPath?, DataSourceElementChangeType, IndexPath?)
  case sectionChange(Int, DataSourceElementChangeType)
}
