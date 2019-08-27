//
//  SettingsViewDataSource.swift
//  StickersCollection
//
//  Created by Nikola Milovanovic on 4/24/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import UIKit

/// Object that is used as tableView datasouce. It uses viewModel datasource and creates cell dippended of settingViewModel type

class SettingsViewDataSource: NSObject, UITableViewDataSource {
  
  private enum Constants {
    static let doubleCellIdentifier = "doubleCell"
  }
  
  private(set) var viewModelDataSource: ViewModelDataSource<SettingCellViewModelProtocol>?
  
  func bindToDataSource(viewModelDataSource: ViewModelDataSource<SettingCellViewModelProtocol>) {
    self.viewModelDataSource = viewModelDataSource
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModelDataSource?.numberOfRowsInSection(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = viewModelDataSource!.cellViewModelForRowAtIndexPath(indexPath)
    
    switch viewModel.type {
    case .double:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.doubleCellIdentifier) as! DoubleTableViewCell
      cell.viewModel = viewModel as! DoubleSettingCellViewModelProtocol
      cell.bindToViewModel()
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModelDataSource?.sectionDataForSection(section)?.name ?? ""
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModelDataSource?.numberOfSections() ?? 0
  }
}
