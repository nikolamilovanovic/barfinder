//
//  ListTableViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListTableViewController: UITableViewController, AppViewController {
  
  private enum Constants {
    static let cellReuseIdentifier = "barCell"
  }
  
  private let disposeBag = DisposeBag()
  
  private let dataSource = BaseTableViewDataSource<BarTableViewCell, BarCellViewModelProtocol>(reuseIdentifier: Constants.cellReuseIdentifier)
  
  var viewModel: ListViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 160
    tableView.dataSource = dataSource
    tableView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.inputs.viewDidAppear()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel.inputs.viewDidDisappear()
  }
  
  func bindViewModel() {
    dataSource.bindToDataSource(viewModelDataSource: viewModel.outputs.dataSource)
    
    // handling dataSource changes
    viewModel.outputs.dataSource.changeObservable.subscribeOnNext { [weak self] (change) in
      self?.handleDataSourceChange(change)
    }.disposed(by: disposeBag)
    
    // present new scene requested by viewModel
    viewModel.outputs.showScene.subscribeOnNext { [weak self] (scene) in
      self?.show(scene.createViewController(), sender: self)
    }.disposed(by: disposeBag)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.inputs.selectedRow(at: indexPath)
  }
  
}
