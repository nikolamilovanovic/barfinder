//
//  FoursquareAPIEnteties.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/15/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation

// Codable entities used for Foursare api jsons decoding for used api version

struct APIResponseFSAPI<Response: Decodable>: Decodable {
  let meta: MetaFSAPI
  let response: Response
}

struct MetaFSAPI: Decodable {
  let code: Int
  let requestId: String
}

struct ResponseSearchVenuesFSAPI: Decodable {
  let venues: [VenueFSAPI]
}

struct ResponseVenueDetailFSAPI: Decodable {
  let venue: VenueFSAPI
}

struct ResponseCategoriesFSAPI: Decodable {
  let categories: [CategoryFSAPI]
}

struct VenueFSAPI: Decodable {
  let id: String
  let name: String
  let location: LocationFSAPI
  let contact: ContactFSAPI?
  let url: String?
  let description: String?
  let bestPhoto: PhotoFSAPI?
}

struct ContactFSAPI: Decodable {
  let phone: String?
  let formattedPhone: String?
  let twitter: String?
  let instagram: String?
  let facebook: String?
  let facebookUsername: String?
  let facebookName: String?
}

struct LocationFSAPI: Decodable {
  let lat: Double
  let lng: Double
  let distance: Int?
  let address: String?
  let crossStreet: String?
  let postalCode: String?
  let cc: String?
  let city: String?
  let state: String?
  let country: String?
  let formattedAddress: [String]?
}

struct PhotoFSAPI: Decodable {
  let id: String
  let prefix: String
  let suffix: String
  let width: Int?
  let height: Int?
}

struct CategoryFSAPI: Decodable {
  let id: String
  let name: String
  let pluralName: String
  let shortName: String
  let categories: [CategoryFSAPI]
}


