//
//  MapViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

final class MapViewController: UIViewController, AppViewController {
  
  fileprivate enum Constants {
    static let barIdentifier = "bar"
  }
  
  let disposeBag = DisposeBag()
  
  var viewModel: MapViewModelProtocol!
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.inputs.viewDidAppear()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    viewModel.inputs.viewDidDisappear()
  }
  
  func bindViewModel() {
    
    // change map region when viewModel inform us about change
    viewModel.outputs.mapPosition.subscribeOnNext { [weak self] (mapPosition) in
      guard let strongSelf = self else { return }
      
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapPosition.currentLocation.coordinate,
                                                                mapPosition.radius * 2,
                                                                mapPosition.radius)
      
      strongSelf.mapView.setRegion(coordinateRegion, animated: true)
    }.disposed(by: disposeBag)
    
    // add/remove annotations in mapView when viewModel informs us about annotation change
    viewModel.outputs.annotations.subscribeOnNext { [weak self] annotations in
      guard let strongSelf = self else { return }
      
      strongSelf.mapView.removeAnnotations(annotations.removed)
      strongSelf.mapView.addAnnotations(annotations.added)
      
    }.disposed(by: disposeBag)
  }
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let view = view as? BarAnotationView else { return }
    
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    view.mapItem().openInMaps(launchOptions: launchOptions)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let barAnnotation = annotation as? BarAnnotation else { return nil }
    
    var view: BarAnotationView

    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.barIdentifier) as? BarAnotationView {
      dequeuedView.annotation = barAnnotation
      view = dequeuedView
    } else {
      view = BarAnotationView(annotation: barAnnotation, reuseIdentifier: Constants.barIdentifier)
    }
    
    return view
  }
}
