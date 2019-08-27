//
//  StickersViewController.swift
//  
//
//  Created by Nikola Milovanovic on 4/21/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit

// This file included code that should be shared between view controllers

// view controller that confirms to this protocol should handle alerts
protocol AlertHandlingViewController {
  func handleAlertWith(alertId: Any, actionId: String)
}

// AppViewController protocol is BindableType and AlertHandlingViewController. All view controllers should be confirmed to this protocol
protocol AppViewController: BindableType, AlertHandlingViewController { }



//MARK: Implementations

extension AlertHandlingViewController where Self: UIViewController {
  
  // Default implementation, do nothing. This is used only for view controllers that wants to show only info alerts
  func handleAlertWith(alertId: Any, actionId: String) {
  }
  
  // helper method that will present alert when arrives alertData from viewModel
  private func showAlertOrAction<T: Equatable>(style: UIAlertControllerStyle, data: AlertData<T>) {
    let alert = UIAlertController(title: data.title, message: data.message, preferredStyle: style)
    
    var actions: [UIAlertAction]
    
    let actionsConverter: ([ActionData]) -> [UIAlertAction] = { actions in
      return actions.map { (actionData) -> UIAlertAction in
        let action = UIAlertAction(title: actionData.title, style: .default) { (_) in
          self.handleAlertWith(alertId: data.id, actionId: actionData.id)
        }
        return action
      }
    }
    
    switch data.type {
    case .info(let okText):
      let action = UIAlertAction(title: okText, style: .default, handler: nil)
      actions = [action]
    case .actions:
      actions = actionsConverter(data.actions)
    case .actionsWithCancel(let cancelText):
      actions = actionsConverter(data.actions)
      let action = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
      actions += [action]
    }
    
    actions.forEach { (action) in
      alert.addAction(action)
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  // helper method for showing alert as alert
  func showAlertWith<Element: Equatable>(_ data: AlertData<Element>) {
    showAlertOrAction(style: .alert, data: data)
  }
  
  // helper method for showing alert as actionSheet
  func showActionSheetWith<Element: Equatable>(_ data: AlertData<Element>) {
    showAlertOrAction(style: .actionSheet, data: data)
  }
}

// Default implementation for handling events from view model data source
extension AppViewController where Self: UITableViewController {
  func handleDataSourceChange(_ dataChange: DataSourceChangeType) {
    switch dataChange {
    case .dataUpdated:
      tableView.reloadData()
    case .contentWillChange:
      tableView.beginUpdates()
    case .contentDidChange:
      tableView.endUpdates()
    case .objectChange(let indexPath, let changeType, let newIndexPath):
      switch changeType {
      case .delete:
        tableView.deleteRows(at: [indexPath!], with: .automatic)
      case .insert:
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
      case .update:
        tableView.reloadRows(at: [indexPath!], with: .automatic)
      case .move:
        tableView.deleteRows(at: [indexPath!], with: .automatic)
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
      }
    case .sectionChange(let index, let changeType):
      switch changeType {
      case .delete:
        tableView.deleteSections([index], with: .automatic)
      case .insert:
        tableView.insertSections([index], with: .automatic)
      case .update:
        tableView.reloadSections([index], with: .automatic)
      case .move:
        return
        //TODO: implement this
      }
    }
  }
}
