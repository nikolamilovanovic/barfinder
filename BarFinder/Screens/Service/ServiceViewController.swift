//
//  ServiceViewController.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ServiceViewController: UIViewController, AppViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: ServiceViewModelProtocol!
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var loggerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bindViewModel() {
    title = viewModel.outputs.title
    
    viewModel.outputs.infolabelText.subscribeOnNext { [weak self] (text) in
      self?.infoLabel.text = text
    }.disposed(by: disposeBag)
    
    viewModel.outputs.buttonTitle.subscribeOnNext { [weak self] (text) in
      self?.loggerButton.setTitle(text, for: UIControlState.normal)
    }.disposed(by: disposeBag)
  }
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    viewModel.inputs.buttonPressed()
  }
}
