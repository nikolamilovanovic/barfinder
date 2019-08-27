//
//  BarDetailsViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/18/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BarDetailsViewController: UIViewController, AppViewController {
  
  var viewModel: BarDetailsViewModelProtocol!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  //MARK: labels and view
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var postalCodeLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var facebookLabel: UILabel!
  @IBOutlet weak var twitterLabel: UILabel!
  @IBOutlet weak var instagramLabel: UILabel!
  @IBOutlet weak var urlLabel: UILabel!
  @IBOutlet weak var bestPhotoImageView: UIImageView!
  
  //MARK: Constraints
  @IBOutlet weak var locationTop: NSLayoutConstraint!
  @IBOutlet weak var addressHeight: NSLayoutConstraint!
  @IBOutlet weak var postalCodeHeight: NSLayoutConstraint!
  @IBOutlet weak var cityHeight: NSLayoutConstraint!
  @IBOutlet weak var stateHeight: NSLayoutConstraint!
  @IBOutlet weak var countryHeight: NSLayoutConstraint!
  @IBOutlet weak var phoneHeight: NSLayoutConstraint!
  @IBOutlet weak var facebookHeight: NSLayoutConstraint!
  @IBOutlet weak var twitterHeight: NSLayoutConstraint!
  @IBOutlet weak var instragramHeight: NSLayoutConstraint!
  @IBOutlet weak var urlHeight: NSLayoutConstraint!
  @IBOutlet weak var bestPhotoHeight: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bindViewModel() {
    nameLabel.text = viewModel.outputs.name
    locationLabel.text = viewModel.outputs.locationString
    
    if let description = viewModel.outputs.descr {
      descriptionLabel.text = description
    } else {
      descriptionLabel.text = ""
      locationTop.constant -= 5
    }
    
    
    if let address = viewModel.outputs.address {
      addressLabel.text = address
    } else {
      addressHeight.constant = 0
    }
    
    if let postalCode = viewModel.outputs.postalCode {
      postalCodeLabel.text = postalCode
    } else {
      postalCodeHeight.constant = 0
    }
    
    if let city = viewModel.outputs.city {
      cityLabel.text = city
    } else {
      cityHeight.constant = 0
    }
    
    if let state = viewModel.outputs.state {
      stateLabel.text = state
    } else {
      stateHeight.constant = 0
    }
    
    if let country = viewModel.outputs.country {
      countryLabel.text = country
    } else {
      countryHeight.constant = 0
    }
    
    if let phone = viewModel.outputs.phone {
      phoneLabel.text = phone
    } else {
      phoneHeight.constant = 0
    }
    
    if let facebook = viewModel.outputs.facebook {
      facebookLabel.text = facebook
    } else {
      facebookHeight.constant = 0
    }
    
    if let twitter = viewModel.outputs.twitter {
      twitterLabel.text = twitter
    } else {
      twitterHeight.constant = 0
    }
    
    if let instagram = viewModel.outputs.instagram {
      instagramLabel.text = instagram
    } else {
      instragramHeight.constant = 0
    }
    
    if let url = viewModel.outputs.url {
      urlLabel.text = url
    } else {
      urlHeight.constant = 0
    }
    
    if let bestPhoto = viewModel.outputs.bestPhoto {
      bestPhotoImageView.image = bestPhoto
      if bestPhoto.size.width > bestPhoto.size.height {
        // if bestPhoto width is larger than height, update bestPhoto height constaint
        // this will be not called here as we always take photos from Foursqare that are dim 500 x 500
        let newBestPhotoHeight = bestPhotoImageView.bounds.size.width * bestPhoto.size.height/bestPhoto.size.width
        bestPhotoHeight.constant = newBestPhotoHeight
      }
    } else {
      bestPhotoHeight.constant = 0
    }
  }
}
