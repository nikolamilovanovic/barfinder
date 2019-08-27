//
//  MainViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation


final class MainTabBarController: UITabBarController, AppViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: MainViewModelProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.inputs.viewDidAppear()
  }
  
  func bindViewModel() {
    let tabs = viewModel.outputs.tabScenes
    
    // adding viewController for scenes
    let scenes = tabs.map { $0.scene }
    let viewControllers = scenes.map { $0.createViewController() }
    setViewControllers(viewControllers, animated: true)
    
    let tabBarItems = tabBar.items!
    
    // adding titles and images for tabs
    (0..<tabs.count).forEach { (index) in
      tabBarItems[index].title = tabs[index].title
      tabBarItems[index].image = ViewDataStore.tabBarImageFor(tabs[index].scene, active: false)
      tabBarItems[index].selectedImage = ViewDataStore.tabBarImageFor(tabs[index].scene, active: true)
    }
    
    selectedIndex = viewModel.outputs.selectedIndexOnStart
    
    // present alert received from viewModel
    viewModel.outputs.showAlert.subscribeOnNext { [weak self] (alertData) in
      self?.showAlertWith(alertData)
    }.disposed(by: disposeBag)
  }
}
