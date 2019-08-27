//
//  ListTableViewCell.swift
//  BarFinder
//
//  Created by Nikola Milovanovic on 5/13/18.
//  Copyright © 2018 Nikola Milovanovic. All rights reserved.
//

import UIKit
import RxSwift

class BarTableViewCell: UITableViewCell, MVVMTableViewCell {

  private let disposeBag = DisposeBag()
  
  @IBOutlet weak var barNameLabel: UILabel!
  @IBOutlet weak var barDescriptionLabel: UILabel!
  @IBOutlet weak var barLinkButton: UIButton!
  @IBOutlet weak var linkHeightConstraint: NSLayoutConstraint!
  
  var viewModel: BarCellViewModelProtocol!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func bindToViewModel() {
    barNameLabel.text = viewModel.outputs.name
    barDescriptionLabel.text = viewModel.outputs.barDescription
    
    // hide linke button if requride by viewModel, it means that bar don't have valid url
    if viewModel.outputs.hideLinkButton {
      barLinkButton.isHidden = viewModel.outputs.hideLinkButton
      linkHeightConstraint.constant = 0
    }
    
    barLinkButton.setTitle(viewModel.outputs.linkButtonTitle, for: UIControlState.normal)
  }

  @IBAction func linkButtonPressed(_ sender: UIButton) {
    viewModel.inputs.linkButtonPressed()
  }
}
