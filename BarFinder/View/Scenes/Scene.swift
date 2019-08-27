//
//  Scene.swift
//  
//
//  Created by Nikola Milovanovic on 4/14/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import UIKit

/// Scene is object that hold all data needed for creating view controller. It has helper method that will create view controller and bind it to viewModel. All view controller must have corresponding Scene object.

fileprivate struct StoryboardData {
  let storyboard: String
  let id: String?
  let embedInNC: Bool
}

enum Scene {

  case main(MainViewModelProtocol)
  case service(ServiceViewModelProtocol)
  case list(ListViewModelProtocol)
  case map(MapViewModelProtocol)
  case settings(SettingsViewModelProtocol)
  case barDetail(BarDetailsViewModelProtocol)
  
  private func createViewController<ViewController: UIViewController & BindableType, ViewModel>(type: ViewController.Type, viewModel: ViewModel, data: StoryboardData) -> UIViewController where ViewController.ViewModelType == ViewModel {
    let storyboard = UIStoryboard(name: data.storyboard, bundle: nil)
    var viewController: ViewController
    if let storyboardId = data.id {
      viewController = storyboard.instantiateViewController(withIdentifier: storyboardId) as! ViewController
    } else {
      viewController = storyboard.instantiateInitialViewController() as! ViewController
    }
    
    viewController.bindViewModel(to: viewModel)
    
    if data.embedInNC {
      return UINavigationController(rootViewController: viewController)
    }
    
    return viewController
  }
  
  func createViewController() -> UIViewController {
    switch self {
    case .main(let viewModel):
      let data = StoryboardData(storyboard: "Main", id: nil, embedInNC: false)
      return createViewController(type: MainTabBarController.self, viewModel: viewModel, data: data)
    case .service(let viewModel):
      let data = StoryboardData(storyboard: "Service", id: nil, embedInNC: true)
      return createViewController(type: ServiceViewController.self, viewModel: viewModel, data: data)
    case .list(let viewModel):
      let data = StoryboardData(storyboard: "List", id: nil, embedInNC: true)
      return createViewController(type: ListTableViewController.self, viewModel: viewModel, data: data)
    case .map(let viewModel):
      let data = StoryboardData(storyboard: "Map", id: nil, embedInNC: true)
      return createViewController(type: MapViewController.self, viewModel: viewModel, data: data)
    case .settings(let viewModel):
      let data = StoryboardData(storyboard: "Settings", id: nil, embedInNC: true)
      return createViewController(type: SettingsTableViewController.self, viewModel: viewModel, data: data)
    case .barDetail(let viewModel):
      let data = StoryboardData(storyboard: "BarDetails", id: nil, embedInNC: false)
      return createViewController(type: BarDetailsViewController.self, viewModel: viewModel, data: data)
    }
  }
}
