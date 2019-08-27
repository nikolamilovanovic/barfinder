//
//  ListCellViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa

protocol BarCellViewModelInputs {
  func linkButtonPressed()
}

protocol BarCellViewModelOutputs {
  var name: String { get }
  var barDescription: String { get }
  var hideLinkButton: Bool { get }
  var linkButtonTitle: String { get }
}

protocol BarCellViewModelProtocol {
  var inputs: BarCellViewModelInputs { get }
  var outputs: BarCellViewModelOutputs { get }
}

final class BarCellViewModel: BarCellViewModelProtocol, BarCellViewModelInputs, BarCellViewModelOutputs {
  
  private let disposeBag: DisposeBag
  
  private let bar: BarMO
  
  var inputs: BarCellViewModelInputs {
    return self
  }
  
  var outputs: BarCellViewModelOutputs {
    return self
  }
  
  private var linkURL: URL?
  
  let name: String
  let barDescription: String
  let hideLinkButton: Bool
  let linkButtonTitle: String
  
  init(bar: BarMO) {
    self.bar = bar
    self.disposeBag = DisposeBag()
    self.name = bar.name ?? ""
    
    let createdAddress = bar.address
      .flatMap {
        $0 + "\n" + (bar.phone ?? "")
      }
    
    let description = bar.descr
      ?? bar.formattedAddress
      ?? createdAddress
      ?? String(bar.lat) + ", " + String(bar.long)
    
    self.barDescription = String(format: LocalizedStrings.ListScreen.distanceFormat, String(bar.distance)) + "\n\n" + description
    
    self.linkButtonTitle = LocalizedStrings.Common.link
    
    let linkURL = bar.url.flatMap { URL(string: $0) }
    self.linkURL = linkURL
    self.hideLinkButton = (linkURL == nil)
  }
  
  func linkButtonPressed() {
    // if link button is pressed, use App method for handlig that
    if let url = linkURL {
      App.current.open(url: url)
    }
  }
}
