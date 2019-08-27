//
//  IntTableViewCell.swift
//
//  Created by Nikola Milovanovic on 4/24/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift

class DoubleTableViewCell: UITableViewCell, MVVMTableViewCell {
  
  let disposeBag = DisposeBag()
  var viewModel: DoubleSettingCellViewModelProtocol!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var settingStepper: UIStepper!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func bindToViewModel() {    
    settingStepper.stepValue = viewModel.outputs.diffValue
    
    titleLabel.text = viewModel.outputs.title
    
    if let minValue = viewModel.outputs.minValue {
      settingStepper.minimumValue = Double(minValue)
    }
    
    if let maxValue = viewModel.outputs.maxValue {
      settingStepper.maximumValue = Double(maxValue)
    }
    
    // change stepper properties, when value si changed
    viewModel.outputs.value.asObservable().subscribeOnNext { [weak self] (value) in
      guard let strongSelf = self else { return }
      
      strongSelf.settingStepper.value = value
      strongSelf.valueLabel.text = "\(Int(value)) m"
    }.disposed(by: disposeBag)
  }
  
  @IBAction func valueChanged(_ sender: UIStepper) {
    viewModel.inputs.valueChanged(to: sender.value)
  }
}
