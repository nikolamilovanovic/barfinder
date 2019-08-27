//
//  SettingsViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelInputs {
}

protocol SettingsViewModelOutputs {
  var dataSource: ViewModelDataSource<SettingCellViewModelProtocol> { get }
}

protocol SettingsViewModelProtocol {
  var inputs: SettingsViewModelInputs { get }
  var outputs: SettingsViewModelOutputs { get }
}

final class SettingsViewModel: SettingsViewModelProtocol, SettingsViewModelInputs, SettingsViewModelOutputs {
  
  private let disposeBag: DisposeBag
  private var genericDataSource: GenericViewModelDataSource<SettingCellViewModelProtocol>!
  
  var inputs: SettingsViewModelInputs {
    return self
  }
  
  var outputs: SettingsViewModelOutputs {
    return self
  }
  
  init() {
    self.disposeBag = DisposeBag()
    self.genericDataSource = GenericViewModelDataSource<SettingCellViewModelProtocol>(content: [])
    
    loadSettings()
  }
  
  var dataSource: ViewModelDataSource<SettingCellViewModelProtocol> {
    return genericDataSource
  }
  
  private func loadSettings() {
    let sectionInfo = SectionInfo(name: LocalizedStrings.SettingsScreen.title)
    
    // Logic for adding new viewModel only on first distance event
    App.current.settings.searchingDistance
      .take(1)
      .subscribeOnNext { [weak self] (value) in
        let searchDistanceViewModel = DoubleSettingCellViewModel(id: SettingCellId.searchingDistance,
                                                                 value: value,
                                                                 diffValue: App.current.settings.diffValue,
                                                                 minValue: App.current.settings.minDistance,
                                                                 maxValue: App.current.settings.maxDistance,
                                                                 title: LocalizedStrings.SettingsScreen.searchingDistance,
                                                                 changeHandler: {
                                                                  App.current.settings.changeSearchingDistance(to: $0)
                                                                })
        
        let sectionData  = SectionData<SettingCellViewModelProtocol>(info: sectionInfo, objects: [searchDistanceViewModel])
        self?.genericDataSource.changeContent(to: [sectionData])
      }.disposed(by: disposeBag)
  }
}
