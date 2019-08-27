//
//  UserDefaultProvider.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// Helper struct to wrap code used for saving and loading Codable objects in userDefauls

struct UserDefaultsCodableProvider {
  
  private let jsonEncoder: JSONEncoder
  private let jsonDecoder: JSONDecoder
  
  init() {
    self.jsonEncoder = JSONEncoder()
    self.jsonDecoder = JSONDecoder()
  }
  
  private var userDefaults: UserDefaults {
    return UserDefaults.standard
  }
  
  /// Load codable objects for key. If there is no data for key it returns nil. If there is data, but data is not valid, removes it from userDefaults
  func loadData<Object: Codable>(for key: String) -> Object? {
    guard let data = userDefaults.object(forKey: key) as? Data else {
      return nil
    }
    
    do {
      let object = try jsonDecoder.decode(Object.self, from: data)
      return object
    } catch {
      print("Error decoding UserData, error: \(error.localizedDescription)")
      userDefaults.removeObject(forKey: key)
      return nil
    }
  }
  
  /// Saves codables objects.
  func save<Object: Codable>(object: Object, for key: String) {
    do {
      let data = try jsonEncoder.encode(object)
      UserDefaults.standard.set(data, forKey: key)
    } catch {
      print("Errod encoding UserData, error:\(error.localizedDescription)")
    }
  }
}
