//
//  RecordingTableViewCell.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

final class RecordingTableViewCell: UITableViewCell, ViewModelBased {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    // MARK: - Variables
    var viewModel: RecordingCellViewModel! {
        didSet { setup(with: viewModel) }
    }
    
    // MARK: - Setup
    private func setup(with viewModel: RecordingCellViewModel) {
        nameLabel.text = viewModel.name
        durationLabel.text = viewModel.duration
    }
}
