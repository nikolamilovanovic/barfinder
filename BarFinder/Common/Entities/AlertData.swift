//
//  AlertData.swift
//  
//
//  Created by Nikola Milovanovic on 4/21/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

/// Type of alerts
enum AlertType {
  case info(String) // Alert that is only info. String is title for ok button if needed
  case actions // Alert that uses some actions.
  case actionsWithCancel(String) // Same as actions, but with cancel button. String is title for cancel button if needed
}

/// Data for action
struct ActionData {
  let id: String
  let title: String?
}

/// Alert data that is used for sending alert from view model to view controllers
struct AlertData<ID> {
  let id: ID
  let type: AlertType
  let title: String?
  let message: String?
  let actions: [ActionData]
}

/// Helper factory methods
extension AlertData {
  static func infoDataWith(id: ID, title: String, message: String) -> AlertData<ID> {
    return AlertData(id: id,
                     type: .info(LocalizedStrings.Common.ok),
                     title: title,
                     message: message,
                     actions: [])
  }
  
  static func cancelDataWith(id: ID, title: String, message: String, actions: [ActionData]) -> AlertData<ID> {
    return AlertData(id: id,
                     type: .actionsWithCancel(LocalizedStrings.Common.cancel),
                     title: title,
                     message: message,
                     actions: actions)
  }
}

