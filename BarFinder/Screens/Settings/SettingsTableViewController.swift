//
//  SettingsTableViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableViewController: UITableViewController, AppViewController {
  
  var viewModel: SettingsViewModelProtocol!
  
  private let dataSource = SettingsViewDataSource()
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    tableView.rowHeight = 60
    tableView.allowsSelection = false
  }
  
  func bindViewModel() {    
    dataSource.bindToDataSource(viewModelDataSource: viewModel.outputs.dataSource)
    
    // reloading data when data source is changed. It should happen only once
    viewModel.outputs.dataSource.changeObservable.subscribeOnNext { [weak self] (_) in
        self?.tableView.reloadData()
    }.disposed(by: disposeBag)
  }
}
