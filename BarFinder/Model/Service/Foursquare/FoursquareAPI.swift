//
//  FoursquareAPI.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/15/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import CoreLocation.CLLocation
import UIKit.UIImage

enum QueueType {
  case main
  case background
}

protocol FoursquareAPIProtocol {
  func getCategories(queue: QueueType) -> Single<APIResponseFSAPI<ResponseCategoriesFSAPI>>
  func getVenues(categoryId: String, location: CLLocation, radius: Int, queue: QueueType) -> Single<APIResponseFSAPI<ResponseSearchVenuesFSAPI>>
  func getVenueDetail(id: String, queue: QueueType) -> Single<APIResponseFSAPI<ResponseVenueDetailFSAPI>>
  func getImageFor(prefix: String, suffix: String, queue: QueueType) -> Single<UIImage?>
}

final class FoursquareAPI: FoursquareAPIProtocol {
  
  private enum Constants {
    enum Params {
      enum Auth {
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
      }
      static let version = "v"
      static let categoryId = "categoryId"
      static let radius = "radius"
      static let location = "ll"
    }
    enum Values {
      enum Auth {
        static let clientId = #clientId#
        static let clientSecret = #clientSecret#

      }
      static let version = "20180323"
      static let locationFormat = "%@,%@"
      static let imageSize = "500x500"
    }
  }
  
  let jsonDecoder: JSONDecoder
  
  let dispatchQueue: DispatchQueue
  
  init() {
    self.jsonDecoder = JSONDecoder()
    self.dispatchQueue = DispatchQueue(label: "queue.serial.foursquareapi")
  }
  
  let apiParams = [
    Constants.Params.Auth.clientId: Constants.Values.Auth.clientId,
    Constants.Params.Auth.clientSecret: Constants.Values.Auth.clientSecret,
    Constants.Params.version: Constants.Values.version
  ]
  
  func getCategories(queue: QueueType) -> Single<APIResponseFSAPI<ResponseCategoriesFSAPI>> {
    let endPoint = "https://api.foursquare.com/v2/venues/categories"
    
    return performGETAPICall(endPoint: endPoint, queue: queue)
  }
  
  func getVenues(categoryId: String, location: CLLocation, radius: Int, queue: QueueType) -> Single<APIResponseFSAPI<ResponseSearchVenuesFSAPI>> {
    let endPoint = "https://api.foursquare.com/v2/venues/search"
    
    let params = [
      Constants.Params.categoryId: categoryId,
      Constants.Params.radius: "\(radius)",
      Constants.Params.location: String(format: Constants.Values.locationFormat, "\(location.coordinate.latitude)", "\(location.coordinate.longitude)")
    ]
    
    return performGETAPICall(endPoint: endPoint, params: params, queue: queue)
  }
  
  func getVenueDetail(id: String, queue: QueueType) -> Single<APIResponseFSAPI<ResponseVenueDetailFSAPI>> {
    let endPoint = "https://api.foursquare.com/v2/venues/" + id
    
    return performGETAPICall(endPoint: endPoint, queue: queue)
  }
  
  // This call will not generate error, as it is not importaing if image is not dowloaded
  func getImageFor(prefix: String, suffix: String, queue: QueueType) -> Single<UIImage?> {
    let endPoint = prefix + Constants.Values.imageSize + suffix
    
    let returnQueue = getQueue(for: queue)
    
    return Single.create { (single) -> Disposable in
      Alamofire.request(endPoint)
        .validate()
        .responseData(queue: returnQueue) { (response) in
          let image = response.result.value.flatMap { UIImage(data: $0) }
          single(.success(image))
      }
      
      return Disposables.create()
    }
  }
  
  private func performGETAPICall<Response: Decodable>(endPoint: String, params: [String: String] = [:], queue: QueueType) -> Single<Response> {
    var requestParams = apiParams
    
    params.forEach { (key, value) in
      requestParams[key] = value
    }
    
    let returnQueue = getQueue(for: queue)
    
    return Single.create { (single) -> Disposable in
      Alamofire.request(endPoint, parameters: requestParams)
        .validate()
        .responseData(queue: returnQueue) { (response) in
          switch response.result {
          case .success(let value):
            do {
              let apiResponse = try self.jsonDecoder.decode(Response.self, from: value)
              single(.success(apiResponse))
            } catch {
              print(error)
              single(.error(error))
            }
          case .failure(let error):
            return single(.error(error))
        }
      }

      return Disposables.create()
    }
  }
  
  private func getQueue(for type: QueueType) -> DispatchQueue? {
    return (type == .background ? dispatchQueue : nil)
  }
}
