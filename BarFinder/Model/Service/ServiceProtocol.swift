//
//  ServiceProtocol.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
  case notImplemented
}

// Type of service, for now it can be twitter or foursquare
enum ServiceType: String {
  case twitter
  case foursquare
  
  var imageName: String {
    return self.rawValue
  }
  
  var localizedName: String {
    return self.rawValue.localized
  }
}

// Fetching status, that will be used by object to fetch objects if needed
enum FetchingStatus {
  case started
  case finished
  case finishedWithNewObjects
}


/// Protocol service
protocol ServiceProtocol {
  var type: ServiceType { get }
  /// if service requires user to be logged in
  var requireLogIn: Bool { get }
  
  /// all errors generated in service, used to inform user about errors
  var errors: Observable<ErrorData> { get }
  /// fetching status
  var fetchingStatus: Observable<FetchingStatus> { get }
  
  /// starting service, must be called when app is launched
  func start()
  
  /// LoggIn user, if loggin is requred, should be implement if requireLogIn is true
  func logIn() -> Single<UserData>
  func logOut()
}

/// Defautl implementatios
extension ServiceProtocol {
  func start() {}
  func logIn() -> Single<UserData> { return Single<UserData>.error(ServiceError.notImplemented) }
  func logOut() {}
}
