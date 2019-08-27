//
//  MapPosition.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/17/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import CoreLocation

/// Objects that wraps currentLocation and radius, used by view model to send map region
struct MapPosition {
  let currentLocation: CLLocation
  let radius: Double
}
