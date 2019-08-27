//
//  Settings.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

/// Settings data used for saving in userDefaults
struct SettingsData: Codable {
  let searchingDistanceInMeters: Double
}
