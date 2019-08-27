//
//  LensType.swift
//  Code from Lens.swift from Kickstarter-Prelude:
//  Link to git: https://github.com/kickstarter/Kickstarter-Prelude
//  Link to Apache Licence 2.0: https://github.com/kickstarter/Kickstarter-Prelude/blob/master/LICENSE
//  Changes: Renaming LensType to LensProtocol

import Foundation

public struct Lens <Whole, Part> : LensProtocol {
  public let view: (Whole) -> Part
  public let set: (Part, Whole) -> Whole
  
  public init(view: @escaping (Whole) -> Part, set: @escaping (Part, Whole) -> Whole) {
    self.view = view
    self.set = set
  }
}
