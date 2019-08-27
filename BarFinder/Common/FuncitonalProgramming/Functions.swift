//
//  Functions.swift
//  SwiftStarter
//
//  Created by Nikola Milovanovic on 4/6/17.
//  Copyright © 2017 Nikola Milovanovic. All rights reserved.
//

import Foundation

public func •<A,B,C>(lhs: @escaping (B) -> C, rhs: @escaping (A) -> B?) -> (A) -> C? {
  return { x in rhs(x).map(lhs) }
}

public func •<A,B,C>(lhs: @escaping (B) -> C?, rhs: @escaping (A) -> B?) -> (A) -> C? {
  return { x in rhs(x).flatMap(lhs) }
}


