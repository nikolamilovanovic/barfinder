//
//  ViewDataManager.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import UIKit

// Singelton (static methods) that includes all data needed by View layer

final class ViewDataStore {
  static func tabBarImageFor(_ scene: Scene, active: Bool) -> UIImage? {
    var imagePrefix: String
    switch scene {
    case .service(_):
      imagePrefix = App.current.service.type.imageName
    case .list(_):
      imagePrefix = "list"
    case .map(_):
      imagePrefix = "map"
    case .settings(_):
      imagePrefix = "settings"
    default:
      imagePrefix = ""
    }
    
    let imageName = imagePrefix + (active ? "_active" : "_inactive")
    
    return UIImage(named: imageName)
  }
  
  static let annotationImage = UIImage(named: "barIcon")!
}
