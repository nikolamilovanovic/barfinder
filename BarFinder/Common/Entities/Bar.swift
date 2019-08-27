//
//  Bar.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/15/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// Object that represent bar, used to map Venues received from Foursqare API to BarMO objects
struct Bar: AutoLens {
  let id: String
  let name: String
  let lat: Double
  let long: Double
  let distance: Int?
  let url: String?
  let description: String?
  let bestPhotoPrefix: String?
  let bestPhotoSuffix: String?
  let bestPhoto: UIImage?
  let phone: String?
  let twitter: String?
  let instagram: String?
  let facebookUsername: String?
  let address: String?
  let postalCode: String?
  let city: String?
  let state: String?
  let country: String?
  let formattedAddress: [String]?
  
  var formattedAddressAsString: String? {
    return formattedAddress
      .flatMap { $0.joined(separator:"\n") }
  }
}
