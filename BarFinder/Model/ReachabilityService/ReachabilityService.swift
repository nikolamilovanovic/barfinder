//
//  ReachabilityService.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/18/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

/// Reachability service that will inform about current reachability status using Observables

protocol ReachabilityServiceProtocol {
  var status: BehaviorRelay<ReachabilityStatus> { get }
  
  func start()
}

enum ReachabilityStatus {
  case unknown
  case notReachable
  case reachableViaWiFi
  case reachableViaWwaN
}

final class ReachabilityService: ReachabilityServiceProtocol {
  
  let manager: NetworkReachabilityManager?
  let status: BehaviorRelay<ReachabilityStatus>
  
  init() {
    self.manager = NetworkReachabilityManager()
    self.status = BehaviorRelay(value: .unknown)
    
    self.manager?.listener = { status in
      var reachabilityStatus: ReachabilityStatus
      switch status {
      case .notReachable:
        reachabilityStatus = .notReachable
      case .reachable(let connectionType):
        switch connectionType {
        case .ethernetOrWiFi:
          reachabilityStatus = .reachableViaWiFi
        case .wwan:
          reachabilityStatus = .reachableViaWwaN
        }
      case .unknown:
        reachabilityStatus = .unknown
      }
      
      self.status.accept(reachabilityStatus)
    }
  }
  
  func start() {
    manager?.startListening()
  }
  
  func stop() {
    manager?.stopListening()
  }
  
}
