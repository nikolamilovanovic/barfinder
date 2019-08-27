//
//  ViewModelsDataSource.swift
//  
//
//  Created by Nikola Milovanovic on 4/24/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


/// Generic view dataSource used as dataSource for tableView or collectionView. 
class GenericViewModelDataSource<CellViewModel>: ViewModelDataSourceProtected<CellViewModel> {
  
  typealias GenericDataSourceContent = [SectionData<CellViewModel>]
  
  private var content: GenericDataSourceContent
  
  init(content: GenericDataSourceContent) {
    self.content = content
    super.init()
  }
  
  override func numberOfSections() -> Int {
    return content.count
  }
  
  override func numberOfRowsInSection(_ section: Int) -> Int {
    return content[section].objects.count
  }
  
  override func sectionDataForSection(_ section: Int) -> SectionInfo? {
    return content[section].info
  }
  
  func object(at indexPath: IndexPath) -> CellViewModel {
    return content[indexPath.section].objects[indexPath.row]
  }
  
  override func cellViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> CellViewModel {
    return object(at: indexPath)
  }
  
  func changeContent(to newContent: GenericDataSourceContent) {
    content = newContent
    changeSubject.onNext(.dataUpdated)
  }
  
  func insert(object: CellViewModel, at indexPath: IndexPath) {
    content[indexPath.section].objects.insert(object, at: indexPath.row)
    changeSubject.onNext(.objectChange(indexPath, .insert, nil))
  }
  
  func update(object: CellViewModel, at indexPath: IndexPath) {
    content[indexPath.section].objects[indexPath.row] = object
    changeSubject.onNext(.objectChange(indexPath, .update, nil))
  }
  
  func moveObject(from: IndexPath, to: IndexPath) {
    let movingObject = object(at: from)
    content[to.section].objects.insert(movingObject, at: to.row)
    changeSubject.onNext(.objectChange(from, .move, to))
  }
  
  func delete(object: CellViewModel, at indexPath: IndexPath) {
    content[indexPath.section].objects.remove(at: indexPath.row)
    changeSubject.onNext(.objectChange(indexPath, .delete, nil))
    
    if content[indexPath.section].objects.count == 0 {
      changeSubject.onNext(.sectionChange(indexPath.section, .delete))
    }
  }
  
  func insert(section: SectionData<CellViewModel>, at index: Int) {
    content.insert(section, at: index)
    changeSubject.onNext(.sectionChange(index, .insert))
  }
  
  func update(section: SectionData<CellViewModel>, at index: Int) {
    content[index] = section
    changeSubject.onNext(.sectionChange(index, .update))
  }
  
  func deleteSection(at index: Int) {
    content.remove(at: index)
    changeSubject.onNext(.sectionChange(index, .delete))
  }
}
