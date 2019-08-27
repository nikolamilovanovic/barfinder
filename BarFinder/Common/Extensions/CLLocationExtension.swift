//
//  CLLocationExtension.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import CoreLocation

/// Extension for CLLocation that enables degree to meters conversion

extension CLLocation {
  var metersPerLatDegree: Double {
    return 111132.954 - 559.822 * cos(Double(2) * coordinate.latitude) + 1.175 * cos(coordinate.latitude * 4)
  }
  
  var metersPerLongDegree: Double {
    return (Double.pi/180) * 6367449 * cos(coordinate.latitude)
  }
  
  func latDegrees(for meters: Double) -> Double {
    return meters / metersPerLatDegree
  }
  
  func longDegrees(for meters: Double) -> Double {
    return meters / metersPerLongDegree
  }
}
