// Generated using Sourcery 0.7.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import UIKit

//MARK: Bar AutoLens
internal extension Bar {
  enum lens {
    internal static let id = Lens<Bar, String>(
      view: { $0.id },
      set: { id, bar in
        Bar(id: id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let name = Lens<Bar, String>(
      view: { $0.name },
      set: { name, bar in
        Bar(id: bar.id, name: name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let lat = Lens<Bar, Double>(
      view: { $0.lat },
      set: { lat, bar in
        Bar(id: bar.id, name: bar.name, lat: lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let long = Lens<Bar, Double>(
      view: { $0.long },
      set: { long, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let distance = Lens<Bar, Int?>(
      view: { $0.distance },
      set: { distance, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let url = Lens<Bar, String?>(
      view: { $0.url },
      set: { url, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let description = Lens<Bar, String?>(
      view: { $0.description },
      set: { description, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let bestPhotoPrefix = Lens<Bar, String?>(
      view: { $0.bestPhotoPrefix },
      set: { bestPhotoPrefix, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let bestPhotoSuffix = Lens<Bar, String?>(
      view: { $0.bestPhotoSuffix },
      set: { bestPhotoSuffix, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let bestPhoto = Lens<Bar, UIImage?>(
      view: { $0.bestPhoto },
      set: { bestPhoto, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let phone = Lens<Bar, String?>(
      view: { $0.phone },
      set: { phone, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let twitter = Lens<Bar, String?>(
      view: { $0.twitter },
      set: { twitter, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let instagram = Lens<Bar, String?>(
      view: { $0.instagram },
      set: { instagram, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let facebookUsername = Lens<Bar, String?>(
      view: { $0.facebookUsername },
      set: { facebookUsername, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let address = Lens<Bar, String?>(
      view: { $0.address },
      set: { address, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let postalCode = Lens<Bar, String?>(
      view: { $0.postalCode },
      set: { postalCode, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let city = Lens<Bar, String?>(
      view: { $0.city },
      set: { city, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: city, state: bar.state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let state = Lens<Bar, String?>(
      view: { $0.state },
      set: { state, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: state, country: bar.country, formattedAddress: bar.formattedAddress)
      })
    internal static let country = Lens<Bar, String?>(
      view: { $0.country },
      set: { country, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: country, formattedAddress: bar.formattedAddress)
      })
    internal static let formattedAddress = Lens<Bar, [String]?>(
      view: { $0.formattedAddress },
      set: { formattedAddress, bar in
        Bar(id: bar.id, name: bar.name, lat: bar.lat, long: bar.long, distance: bar.distance, url: bar.url, description: bar.description, bestPhotoPrefix: bar.bestPhotoPrefix, bestPhotoSuffix: bar.bestPhotoSuffix, bestPhoto: bar.bestPhoto, phone: bar.phone, twitter: bar.twitter, instagram: bar.instagram, facebookUsername: bar.facebookUsername, address: bar.address, postalCode: bar.postalCode, city: bar.city, state: bar.state, country: bar.country, formattedAddress: formattedAddress)
      })
  }
}

