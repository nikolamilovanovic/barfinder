//
//  LocationService.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

// Location service that will inform subscribers about location change using Observables.

enum LocationServiceError: Error {
  case serviceDenied
}

protocol LocationServiceProtocol {
  // errors with location, including error when user turn off location service
  var errors: Observable<ErrorData> { get }
  
  // getting Location observable that will send new events only when location change is larger than required distance
  func getLocation(minimumDistanceChange: Double) -> Observable<CLLocation>
  
  // same as getLocation(minimumDistanceChange:), only with default distance value
  func getLocation() -> Observable<CLLocation>
  
  // starting Location service. This must be called when view is opened
  func start()
}

final class LocationService: NSObject, LocationServiceProtocol {
  
  private enum Constants {
    static let minimumDistance = 50.0
  }
  
  private let locationManager: CLLocationManager
  
  private let locationSubject: ReplaySubject<CLLocation>
  private let errorsSubject: ReplaySubject<ErrorData>
  
  override init() {
    self.locationManager = CLLocationManager()
    self.locationSubject = ReplaySubject.create(bufferSize: 1)
    self.errorsSubject = ReplaySubject.create(bufferSize: 1)
    super.init()
  }
  
  func getLocation() -> Observable<CLLocation> {
    return getLocation(minimumDistanceChange: Constants.minimumDistance)
  }
  
  func getLocation(minimumDistanceChange: Double) -> Observable<CLLocation> {
    // sending events only on first event and when distance between new location and previous location is larger than minimumDistanceChange
    return locationSubject
      .scan((nil, false)) { prev, newLocation -> (CLLocation, Bool) in
        if let previousLocation = prev.0, previousLocation.distance(from: newLocation) < minimumDistanceChange {
          return (previousLocation, false)
        }
        
        return (newLocation, true)
      }.filter { _, shouldInform in
        return shouldInform
      }.map { location, _ in
        return location!
    }
  }
    
  var errors: Observable<ErrorData> {
    return errorsSubject
  }
  
  func start() {
    locationManager.delegate = self
    handleCurrentStatus()
  }
  
  // handling current location service status and act properly
  private func handleCurrentStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      // on first lauch ask for permission
      locationManager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      // if it is authorized, start gethering data
      startGetheringDataIfPossible()
    case .denied:
      // send error that should inform user that is should enable location service for properly using application. Stops gethering data
      let errorData = ErrorData(error: LocationServiceError.serviceDenied,
                                title: LocalizedStrings.Location.errorNoServiceTitle,
                                message: LocalizedStrings.Location.errorNoServiceMessage)
      stopGenetheringData()
      errorsSubject.onNext(errorData)
    default:
      break
    }
  }
  
  private func startGetheringDataIfPossible() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.distanceFilter = Constants.minimumDistance
      locationManager.startUpdatingLocation()
    }
  }
  
  private func stopGenetheringData() {
    locationManager.stopUpdatingLocation()
  }
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locationManager.location else {
      return
    }
    
    // send new location event
    locationSubject.onNext(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    handleCurrentStatus()
  }
}
