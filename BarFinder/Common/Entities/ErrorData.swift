//
//  ErrorData.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/14/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

/// Error data, used for presenting errors via alerts
struct ErrorData {
  let error: Error
  let title: String
  let message: String
}
