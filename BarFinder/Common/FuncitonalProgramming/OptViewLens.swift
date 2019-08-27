//
//  LensExtension.swift
//  SwiftStarter-iOS
//
//  Created by Nikola Milovanovic on 5/27/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

public protocol OptViewLensProtocol {
  associatedtype Whole
  associatedtype Part
  
  var view: (Whole) -> Part? { get }
  var set: (Part, Whole) -> Whole { get }
}

public struct OptViewLens<A,B>: OptViewLensProtocol {
  public typealias Whole = A
  public typealias Part = B
  
  public var view: (Whole) -> Part?
  public var set: (Part, Whole) -> Whole
  
  fileprivate init(view: @escaping (Whole) -> Part?, set: @escaping (Part, Whole) -> Whole) {
    self.view = view
    self.set = set
  }
}

public extension LensProtocol {
  
  fileprivate func compose2<T, RLens: LensProtocol>(_ rhs: RLens) -> Lens<Whole,T?> where Part == RLens.Whole?, RLens.Part == T? {
    return Lens(
      view: rhs.view • self.view,
      set: { subpart, whole in
        let part = self.view(whole)
        let newPart = part.map { rhs.set(subpart, $0) }
        return self.set(newPart, whole)
    })
  }
  
  fileprivate func compose3<RLens: LensProtocol>(_ rhs: RLens) -> OptViewLens<Whole,RLens.Part> where Part == RLens.Whole? {
    return OptViewLens(
      view: rhs.view • self.view,
      set: { subpart, whole in
        let part = self.view(whole)
        let newPart = part.map { rhs.set(subpart, $0) }
        return self.set(newPart, whole)
    })
  }
}


public func •<A,B,C>(lhs: Lens<A,B?>, rhs: Lens<B,C?>) -> Lens<A,C?> {
  return lhs.compose2(rhs)
}

public func •<A,B,C>(lhs: Lens<A,B?>, rhs: Lens<B,C>) -> OptViewLens<A,C> {
  return lhs.compose3(rhs)
}

public extension OptViewLensProtocol {
  
  func over(_ f: @escaping (Part) -> Part) -> (Whole) -> Whole {
    return { whole in
      let newPart = self
        .view(whole)
        .map(f)
      return newPart == nil ? whole : self.set(newPart!, whole)
    }
  }
  
  fileprivate func compose<RLens: LensProtocol>(_ rhs: RLens) -> OptViewLens<Whole,RLens.Part> where Part == RLens.Whole {
    return OptViewLens(
      view: rhs.view • self.view,
      set: { subpart, whole in
        if let part = self.view(whole) {
          let newPart = rhs.set(subpart, part)
          return self.set(newPart, whole)
        }
        return whole
    })
  }
  
  fileprivate func compose2<T, RLens: LensProtocol>(_ rhs: RLens) -> Lens<Whole,T?> where Part == RLens.Whole, RLens.Part == T? {
    return Lens(
      view: rhs.view • self.view,
      set: { subpart, whole in
        if let part = self.view(whole) {
          let newPart = rhs.set(subpart, part)
          return self.set(newPart, whole)
        }
        return whole
    })
  }
}

public func .~ <L: OptViewLensProtocol>(lens: L, part: L.Part) -> (L.Whole) -> L.Whole {
  return { whole in
    lens.set(part, whole)
  }
}

public func ^* <L: OptViewLensProtocol>(whole: L.Whole, lens: L) -> L.Part? {
  return lens.view(whole)
}

public func •<A,B,C>(lhs: OptViewLens<A,B>, rhs: Lens<B,C>) -> OptViewLens<A,C> {
  return lhs.compose(rhs)
}

public func •<A,B,C>(lhs: OptViewLens<A,B>, rhs: Lens<B,C?>) -> Lens<A,C?> {
  return lhs.compose2(rhs)
}

public func %~ <L: OptViewLensProtocol> (lens: L, f: @escaping (L.Part) -> L.Part) -> ((L.Whole) -> L.Whole) {
  return lens.over(f)
}


// Ne podrzavam ovo jer uopste ne znam zasto se koristi zato nije ni pokriveno testovima

//public func %~~ <L: OptViewLensProtocol> (lens: L, f: @escaping (L.Part, L.Whole) -> L.Part) -> ((L.Whole) -> L.Whole) {
//  return { whole in
//    if let part = lens.view(whole) {
//      return lens.set(f(part, whole), whole)
//    }
//    return whole
//  }
//}
