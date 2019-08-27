//
//  LensType.swift
//  Code from LensType.swift from Kickstarter-Prelude:
//  Link to git: https://github.com/kickstarter/Kickstarter-Prelude
//  Link to Apache Licence 2.0: https://github.com/kickstarter/Kickstarter-Prelude/blob/master/LICENSE
//  Changes:
//  1) Renaming LensType to LensProtocol
//  2) Removing code for comparator computed variable, func >•> and func <>~

public protocol LensProtocol {
  associatedtype Whole
  associatedtype Part
  
  init(view: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole)
  
  var view: (Whole) -> Part { get }
  var set: (Part, Whole) -> Whole { get }
}

public extension LensProtocol {
  /**
   Map a function over a part of a whole.
   - parameter f: A function.
   - returns: A function that takes wholes to wholes by applying the function to a subpart.
   */
  func over(_ f: @escaping (Part) -> Part) -> ((Whole) -> Whole) {
    return { whole in
      let part = self.view(whole)
      return self.set(f(part), whole)
    }
  }
  
  /**
   Composes two lenses. Given lenses `Lens<A, B>` and `Lens<B, C>` it is possible to construct a lens
   `Lens<A, C>`.
   - parameter rhs: Another lens.
   - returns: A composed lens.
   */
  func compose <RLens: LensProtocol>(_ rhs: RLens) -> Lens<Whole, RLens.Part> where RLens.Whole == Part {
    return Lens(
      view: { x in rhs.view(self.view(x)) }, // ovde bi trebalo da stoji rhs.view • self.view ali zbog problema sa svim OS osim iOS ovo stoji tako
      set: { subPart, whole in
        let part = self.view(whole)
        let newPart = rhs.set(subPart, part)
        return self.set(newPart, whole)
    }
    )
  }
}

/**
 Infix operator of the `set` function.
 - parameter lens: A lens.
 - parameter part: A part.
 - returns: A function that transforms a whole into a new whole with a part replaced.
 */
public func .~ <L: LensProtocol> (lens: L, part: L.Part) -> ((L.Whole) -> L.Whole) {
  return { whole in lens.set(part, whole) }
}

/**
 Infix operator of the `view` function.
 - parameter whole: A whole.
 - parameter lens:  A lens.
 - returns: A part of a whole when viewed through the lens provided.
 */
public func ^* <L: LensProtocol> (whole: L.Whole, lens: L) -> L.Part {
  return lens.view(whole)
}

/**
 Infix operator of `compose`, which composes two lenses.
 - parameter lhs: A lens.
 - parameter rhs: A lens.
 - returns: The composed lens.
 */
public func • <A, B, C> (lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
  return lhs.compose(rhs)
}

/**
 Infix operator of the `over` function.
 - parameter lens: A lens.
 - parameter f:    A function for transforming a part of a whole.
 - returns: A function that transforms a whole into a new whole with its part transformed by `f`.
 */
public func %~ <L: LensProtocol> (lens: L, f: @escaping (L.Part) -> L.Part) -> ((L.Whole) -> L.Whole) {
  return lens.over(f)
}

/**
 Variation of the infix operator %~.
 - parameter lens: A lens.
 - parameter f:    A function for transforming a part and whole into a new part.
 - returns: A function that transforms a whole into a new whole with its part transformed by `f`.
 */
public func %~~ <L: LensProtocol> (lens: L, f: @escaping (L.Part, L.Whole) -> L.Part) -> ((L.Whole) -> L.Whole) {
  return { whole in
    let part = lens.view(whole)
    return lens.set(f(part, whole), whole)
  }
}

