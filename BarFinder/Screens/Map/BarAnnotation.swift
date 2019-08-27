//
//  BarAnnotation.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/14/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import MapKit

class BarAnnotation: NSObject, MKAnnotation {
  
  let coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  
  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
  
  init(bar: BarMO) {
    self.coordinate = CLLocationCoordinate2D(latitude: bar.lat, longitude: bar.long)
    self.title = bar.name
    self.subtitle = bar.address ?? ""
  }
  
  var image: UIImage {
    return ViewDataStore.annotationImage
  }
}

extension BarAnnotation {
  static func ==(lhs: BarAnnotation, rhs: BarAnnotation) -> Bool {
    return lhs.coordinate.latitude == rhs.coordinate.latitude
      && lhs.coordinate.longitude == rhs.coordinate.longitude
  }
}
