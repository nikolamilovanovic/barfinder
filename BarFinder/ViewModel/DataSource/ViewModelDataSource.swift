//
//  ViewModelDataSource.swift
//  
//
//  Created by Nikola Milovanovic on 4/16/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift

struct SectionInfo {
  let name: String
  let indexTitle: String?
  let footerText: String?
}

extension SectionInfo {
  init(name: String) {
    self.name = name
    self.indexTitle = nil
    self.footerText = nil
  }
  
  init(name: String, indexTitle: String?) {
    self.name = name
    self.indexTitle = indexTitle
    self.footerText = nil
  }
}

struct SectionData<Object> {
  let info: SectionInfo
  var objects: [Object]
}


/// ViewModelDataSource base class. As data source must be generic this base class exist for viewModel can have some generic value for data source. Using protocol with associateValue can't be used for that purpose. This class must be subsclased and all methods must be overriden.
class ViewModelDataSource<CellViewModel>: NSObject {
  
  func cellViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> CellViewModel {
    fatalError("cellViewModelForRowAtIndexPath not implemented")
  }
  
  func numberOfSections() -> Int {
    fatalError("numberOfSections not implemented")
  }
  
  func numberOfRowsInSection(_ section: Int) -> Int {
    fatalError("numberOfRowsInSection not implemented")
  }
  
  func sectionDataForSection(_ section: Int) -> SectionInfo? {
    fatalError("sectionDataForSection not implemented")
  }
  
  var changeObservable: Observable<DataSourceChangeType> {
    fatalError("changeObservable not implemented")
  }
}

