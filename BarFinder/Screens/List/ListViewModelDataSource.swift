//
//  ListViewModelDataSource.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

final class ListViewModelDataSource: FRCDataSourceBaseClass<BarMO, BarCellViewModelProtocol> {
  
  // Overriding method that will create right viewModel object
  override func cellViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> BarCellViewModelProtocol {
    let bar = fetchResultsController!.object(at: indexPath)
    return BarCellViewModel(bar: bar)
  }
}
