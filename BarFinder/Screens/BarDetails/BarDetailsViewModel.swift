//
//  BarDetailsViewModel.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/18/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BarDetailsViewModelInputs: AppViewModelInputs {
}

protocol BarDetailsViewModelOutputs: AppViewModelOutputs {
  var name: String { get }
  var distance: String { get }
  var locationString: String { get }
  var url: String? { get }
  var descr: String? { get }
  var bestPhoto: UIImage? { get }
  var phone: String? { get }
  var twitter: String? { get }
  var instagram: String? { get }
  var facebook: String? { get }
  var address: String? { get }
  var postalCode: String? { get }
  var city: String? { get }
  var state: String? { get }
  var country: String? { get }
  var formattedAddress: String? { get }
}

protocol BarDetailsViewModelProtocol {
  var inputs: BarDetailsViewModelInputs { get }
  var outputs: BarDetailsViewModelOutputs { get }
}

final class BarDetailsViewModel: AppViewModel, BarDetailsViewModelProtocol, BarDetailsViewModelInputs, BarDetailsViewModelOutputs {
  
  var inputs: BarDetailsViewModelInputs {
    return self
  }
  
  var outputs: BarDetailsViewModelOutputs {
    return self
  }
  
  let name: String
  let distance: String
  let locationString: String
  let url: String?
  let descr: String?
  let bestPhoto: UIImage?
  let phone: String?
  let twitter: String?
  let instagram: String?
  let facebook: String?
  let address: String?
  let postalCode: String?
  let city: String?
  let state: String?
  let country: String?
  let formattedAddress: String?
  
  init(bar: BarMO) {
    self.name = bar.name!
    self.distance = String(format: LocalizedStrings.BarDetail.distanceFormat, String(bar.distance))
    
    let latRounded = round(bar.lat * 10000)/10000
    let longRounded = round(bar.long * 10000)/10000
    self.locationString = String(format: LocalizedStrings.BarDetail.locationFormat, String(latRounded), String(longRounded))
    
    self.url = bar.url.map { String(format: LocalizedStrings.BarDetail.urlFormat, $0) }
    self.descr = bar.descr
    self.bestPhoto = bar.bestPhoto?.image
    self.phone = bar.phone.map { String(format: LocalizedStrings.BarDetail.phoneFormat, $0) }
    self.twitter = bar.twitter.map { String(format: LocalizedStrings.BarDetail.twitterFormat, $0) }
    self.instagram = bar.instagram.map { String(format: LocalizedStrings.BarDetail.instagramFormat, $0) }
    self.facebook = bar.facebookUsername.map { String(format: LocalizedStrings.BarDetail.facebookFormat, $0) }
    self.address = bar.address.map { String(format: LocalizedStrings.BarDetail.addressFormat, $0) }
    self.postalCode = bar.postalCode.map { String(format: LocalizedStrings.BarDetail.postalCodeFormat, $0) }
    self.city = bar.city.map { String(format: LocalizedStrings.BarDetail.cityFormat, $0) }
    self.state = bar.state.map { String(format: LocalizedStrings.BarDetail.stateFormat, $0) }
    self.country = bar.country.map { String(format: LocalizedStrings.BarDetail.countryFormat, $0) }
    self.formattedAddress = bar.formattedAddress.map { String(format: LocalizedStrings.BarDetail.formattedAddressFormat, $0) }
    super.init()
  }
}
