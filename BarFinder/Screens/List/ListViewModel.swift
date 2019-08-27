//
//  ListViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListViewModelInputs: AppViewModelInputs {
  func selectedRow(at indexPath: IndexPath)
}

protocol ListViewModelOutputs: AppViewModelOutputs {
  var dataSource: ViewModelDataSource<BarCellViewModelProtocol> { get }
  var showScene: Observable<Scene> { get }
}

protocol ListViewModelProtocol {
  var inputs: ListViewModelInputs { get }
  var outputs: ListViewModelOutputs { get }
}

final class ListViewModel: AppViewModel, ListViewModelProtocol, ListViewModelInputs, ListViewModelOutputs {
  
  private let listDataSource: ListViewModelDataSource
  private let showSceneSubject: PublishSubject<Scene>
  
  var inputs: ListViewModelInputs {
    return self
  }
  
  var outputs: ListViewModelOutputs {
    return self
  }
  
  override init() {
    self.listDataSource = ListViewModelDataSource(fetchResultsController: nil)
    self.showSceneSubject = PublishSubject()
    
    super.init()
    
    bindToObservables()
  }
  
  private func bindToObservables() {
    let location = App.current.locationService.getLocation()
    let distance = App.current.settings.searchingDistance
    
    // Observable that will send only one event when view is first time opened and than complets
    let viewFirstOpen = viewStatusSubject
      .filter { $0 }
      .take(1)
    
    // Logic for perform fetch when location or distance is changed and view is visible
    Observable.combineLatest(location, distance, viewFirstOpen).subscribeOnNext { [weak self] (location, distance, _) in
      guard let strongSelf = self else { return }
      
      let predicate = App.current.barsDataController.getBarPredicate(currentLocation: location ,
                                                                     maxDistance: distance)
      
      if strongSelf.listDataSource.fetchResultsController == nil {
        let frc = App.current.barsDataController.getBarsFRC()
        frc.fetchRequest.predicate = predicate
        strongSelf.listDataSource.fetchResultsController = frc
        // setting fetchResultController to dataSource will automaticly trigger fetch
      } else {
        strongSelf.listDataSource.changePredicate(predicate)
        // changing predicate to dataSource will automaticly trigger fetch
      }
      
      // when fetching is finished update all BarMO objects with current location
      App.current.barsDataController.updateBars(for: location)
                                                               
    }.disposed(by: disposeBag)
  }
  
  var dataSource: ViewModelDataSource<BarCellViewModelProtocol> {
    return listDataSource
  }
  
  var showScene: Observable<Scene> {
    return showSceneSubject
  }
  
  /// On row selected inform view to show new scene
  func selectedRow(at indexPath: IndexPath) {
    let bar = listDataSource.object(at: indexPath)
    let viewModel = BarDetailsViewModel(bar: bar)
    let scene: Scene = .barDetail(viewModel)
    
    showSceneSubject.onNext(scene)
  }
}
