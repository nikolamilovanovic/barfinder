//
//  BaseTableViewDataSource.swift
//  
//
//  Created by Nikola Milovanovic on 4/16/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit

protocol MVVMTableViewCell {
  associatedtype CellViewModel
  var viewModel: CellViewModel! { get set }
  func bindToViewModel()
}

// Generic Base Table View Data Source, that connets to view model data source. In most cases it is good enough for using it directly as tableView dataSource withot subclassing. If it has to implement some special logic, subclassed should be created.

class BaseTableViewDataSource<CellClass: UITableViewCell & MVVMTableViewCell, CellViewModel>: NSObject, UITableViewDataSource where CellClass.CellViewModel == CellViewModel {
  
  private(set) var viewModelDataSource: ViewModelDataSource<CellViewModel>?
  private let reuseIdentifier: String
  
  init(reuseIdentifier: String) {
    self.reuseIdentifier = reuseIdentifier
  }
  
  func bindToDataSource(viewModelDataSource: ViewModelDataSource<CellViewModel>) {
    self.viewModelDataSource = viewModelDataSource
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModelDataSource?.numberOfRowsInSection(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellClass
    
    let viewModel = viewModelDataSource?.cellViewModelForRowAtIndexPath(indexPath)
    
    cell.viewModel = viewModel
    cell.bindToViewModel()
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModelDataSource?.sectionDataForSection(section)?.name ?? ""
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModelDataSource?.numberOfSections() ?? 0
  }
}
