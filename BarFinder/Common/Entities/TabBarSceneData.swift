//
//  TabBarSceneData.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// Data used for sending informations about tabs from view model to TabBarController instance
// It includes screen Scene property and title

struct TabBarSceneData {
  let scene: Scene
  let title: String
}
