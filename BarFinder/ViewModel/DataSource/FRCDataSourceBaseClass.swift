//
//  FTCDataSource.swift
//  
//
//  Created by Nikola Milovanovic on 4/16/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

fileprivate extension NSFetchedResultsChangeType {
  var dataSourceElementChangeType: DataSourceElementChangeType {
    switch self {
    case .delete:
      return .delete
    case .insert:
      return .insert
    case .move:
      return .move
    case .update:
      return .update
    }
  }
}

/// Class that wraps NSFetchedResultsController to be used as view model data source with Rx.
class FRCDataSourceBaseClass<ObjectMO: NSManagedObject, CellViewModel>: ViewModelDataSourceProtected<CellViewModel>, NSFetchedResultsControllerDelegate {
  
  var fetchResultsController: NSFetchedResultsController<ObjectMO>? {
    didSet {
      newFetchedResultsControllerSetted()
    }
  }
  
  init(fetchResultsController: NSFetchedResultsController<ObjectMO>?) {
    self.fetchResultsController = fetchResultsController
    super.init()
    newFetchedResultsControllerSetted()
  }
  
  // fetching data when new NSFetchedResultsController is setted
  private func newFetchedResultsControllerSetted() {
    guard fetchResultsController == self.fetchResultsController else {
      return
    }
    self.fetchResultsController?.delegate = self
    fetchData()
  }
  
  // fetching data
  private func fetchData() {
    do {
      try fetchResultsController?.performFetch()
      self.changeSubject.onNext(.dataUpdated)
    } catch {
      print("Error fetching data in FRCDataSourceBaseClass: \(error)")
    }
  }
  
  //MARK: NSFetchedResultsControllerDelegate
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    changeSubject.onNext(.contentWillChange)
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    changeSubject.onNext(.contentDidChange)
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    changeSubject.onNext(.objectChange(indexPath, type.dataSourceElementChangeType, newIndexPath))
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    changeSubject.onNext(.sectionChange(sectionIndex, type.dataSourceElementChangeType))
  }
  
  override func numberOfSections() -> Int {
    return fetchResultsController?.sections?.count ?? 0
  }
  
  override func numberOfRowsInSection(_ section: Int) -> Int {
    guard let sections = fetchResultsController?.sections else {
      return 0
    }
    
    return sections[section].numberOfObjects
  }
  
  override func sectionDataForSection(_ section: Int) -> SectionInfo? {
    guard let sections = fetchResultsController?.sections else {
      return nil
    }
    
    let section = sections[section]
    
    return SectionInfo(name: section.name, indexTitle: section.indexTitle)
  }
  
  func object(at indexPath: IndexPath) -> ObjectMO {
    return fetchResultsController!.object(at: indexPath)
  }
  
  /// changing predicate. it will change predicate and fetch new objects
  func changePredicate(_ predicate: NSPredicate) {
    fetchResultsController?.fetchRequest.predicate = predicate
    fetchData()
  }
}


