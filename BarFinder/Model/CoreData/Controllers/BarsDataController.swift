//
//  BarsDataController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

// Wrapper around coreDataController with helper methods for getting and updating bars

protocol BarsDataControllerProtocol {
  // getting bars FetchResultController, it doesn't contain any predicate when is created, so predicate, if needed, must be added before fetch
  func getBarsFRC() -> NSFetchedResultsController<BarMO>
  // getting all bars in region with center in current location and radus of maxDistance. Because of predicate limitations it may include bars that are little bit outside maxDistance
  func getBars(currentLocation: CLLocation, maxDistance: Double) -> [BarMO]
  // getting predicate for location and maxDistance. Limitations are the same as for getBars(currentLocation:maxDistance:)
  func getBarPredicate(currentLocation: CLLocation, maxDistance: Double) -> NSPredicate
  // update bars distance properties for current location. It will only updates bars contained in managed object context. It should be called when fetching is finished (if that property is needed) and by DistanceSynchorizer on location change
  func updateBars(for currentLocation: CLLocation)
  // saving changes in core data
  func saveChanges()
}

final class BarsDataController: BarsDataControllerProtocol {
  
  let coreDataController: CoreDataControllerProtocol
  
  init(coreDataController: CoreDataControllerProtocol) {
    self.coreDataController = coreDataController
  }
  
  var moc: NSManagedObjectContext {
    return coreDataController.persistentContainer.viewContext
  }
    
  func getBarsFRC() -> NSFetchedResultsController<BarMO> {
    let fetchRequest = getBarsFetchRequest()
    
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  func getBars(currentLocation: CLLocation, maxDistance: Double) -> [BarMO] {
    let fetchRequest = getBarsFetchRequest()
    fetchRequest.predicate = getBarPredicate(currentLocation: currentLocation, maxDistance: maxDistance)
    do {
      let bars = try moc.fetch(fetchRequest)
      return bars
    } catch {
      print("Error fetching bars: \(error)")
      return []
    }
  }
  
  private func getBarsFetchRequest() -> NSFetchRequest<BarMO> {
    let fetchRequest: NSFetchRequest<BarMO> = BarMO.fetchRequest()
    let sortDescriptior = NSSortDescriptor(key: "distance", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptior]
    return fetchRequest
  }
  
  // this predicate will return bars little bit outside maxDistance as it uses rectangle region and not elipsoid region. This is only way of getting bars. Distance property can't be used as there is no guarantee that that property is refreshed.
  func getBarPredicate(currentLocation: CLLocation, maxDistance: Double) -> NSPredicate {
    let diffLat = currentLocation.latDegrees(for: maxDistance)
    let diffLong = currentLocation.longDegrees(for: maxDistance)
    
    let latMinValue = currentLocation.coordinate.latitude - diffLat
    let latMaxValue = currentLocation.coordinate.latitude + diffLat
    let longMinValue = currentLocation.coordinate.longitude - diffLong
    let longMaxValue = currentLocation.coordinate.longitude + diffLong
    
    return NSPredicate(format: "lat >= %lf && lat <= %lf && long >= %lf && long <= %lf",
                       latMinValue, latMaxValue, longMinValue, longMaxValue)
  }
  
  func updateBars(for currentLocation: CLLocation) {
    moc.perform {
      self.moc.registeredObjects.forEach { (managedObject) in
        guard let bar = managedObject as? BarMO else { return }
        
        let barLocation = CLLocation(latitude: bar.lat, longitude: bar.long)
        bar.distance = Int64(barLocation.distance(from: currentLocation))
      }
      
      self.saveChanges()
    }
  }
  
  func saveChanges() {
    coreDataController.saveContext()
  }
}
