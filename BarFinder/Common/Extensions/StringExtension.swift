//
//  Extensions.swift
//  
//
//  Created by Nikola Milovanovic on 4/21/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

/// Extension for easaly get Localization string from string
extension String {
  var localized: String {
    return localizedWithComment("")
  }
  
  func localizedWithComment(_ comment: String) -> String {
    return NSLocalizedString(self, comment: comment)
  }
}
