//
//  LocalizedString.swift
//  
//
//  Created by Nikola Milovanovic on 4/21/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

enum LocalizedStrings {
  
  enum Common {
    static let cancel = "cancel".localized
    static let ok = "ok".localized
    static let error = "error".localized
    static let link = "link".localized
  }
  
  enum ServiceScreen {
    static let title = "twitter".localized
    static let userLoggedFormat = "serviceScreenUserLoggedFormat".localized
    static let userNotLoggedFormat = "serviceScreenUserNotLoggedFormat".localized
    static let buttonTitleLogIn = "serviceScreenButtonTitleLogIn".localized
    static let buttonTitleLogOut = "serviceScreenButtonTitleLogOut".localized
  }
  
  enum ListScreen {
    static let title = "list".localized
    static let distanceFormat = "listScreenDistanceFormat".localized
  }
  
  enum MapScreen {
    static let title = "map".localized
  }
  
  enum SettingsScreen {
    static let title = "settings".localized
    static let searchingDistance = "settingsScreenSerchingDistance".localized
  }
  
  enum Location {
    static let errorNoServiceTitle = "locationErrorNoServiceEnableTitle".localized
    static let errorNoServiceMessage = "locationErrorNoServiceEnableMessage".localized
  }
  
  enum BarDetail {
    static let nameFormat = "barDetailsNameFormat".localized
    static let locationFormat = "barDetailsLocationFormat".localized
    static let distanceFormat = "barDetailsDistanceFormat".localized
    static let urlFormat = "barDetailsUrlFormat".localized
    static let descriptionFormat = "barDetailsDescriptionFormat".localized
    static let phoneFormat = "barDetailsPhoneFormat".localized
    static let twitterFormat = "barDetailsTwitterFormat".localized
    static let instagramFormat = "barDetailsInstagramFormat".localized
    static let facebookFormat = "barDetailsFacebookFormat".localized
    static let addressFormat = "barDetailsAddresFormat".localized
    static let postalCodeFormat = "barDetailsPostalCodeFormat".localized
    static let cityFormat = "barDetailsCityFormat".localized
    static let stateFormat = "barDetailsStateFormat".localized
    static let countryFormat = "barDetailsCountryFormat".localized
    static let formattedAddressFormat = "barDetailsFomratedAddressFormat".localized
  }
}
