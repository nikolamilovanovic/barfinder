//
//  BarAnnotationView.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/14/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class BarAnotationView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let barAnnotation = newValue as? BarAnnotation else {
        return
      }
      
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      
      glyphImage = barAnnotation.image
    }
  }
  
  func mapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: annotation!.subtitle!!]
    let placemark = MKPlacemark(coordinate: annotation!.coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = annotation!.title!
    return mapItem
  }
}
