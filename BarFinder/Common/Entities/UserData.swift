//
//  UserData.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

typealias UserDataId = String

// User data for user connected to service. It is used only for services that need user to be logged in. It was used for Twitter API, but not for FourSquare API
struct UserData: Codable, Equatable {
  let id: UserDataId
  let name: String?
}
