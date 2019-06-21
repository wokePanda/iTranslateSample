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
    private var timer: Timer?
    
    // MARK: - Setup
    private func setup(with viewModel: RecordingCellViewModel) {
        nameLabel.text = viewModel.name
        durationLabel.text = viewModel.durationString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { startCountdown() }
    }
    
    func reset() {
        self.timer?.invalidate()
        backgroundColor = .white
        durationLabel.textColor = .babyBlue
        nameLabel.textColor = .black
        durationLabel.text = viewModel.durationString
    }
    
    private func startCountdown() {
        backgroundColor = .fadedGray
        durationLabel.textColor = .white
        nameLabel.textColor = .white
        var repeats = 0
        guard let oneSecondInterval = TimeInterval(exactly: 1.0) else { return }
        timer = Timer.scheduledTimer(withTimeInterval: oneSecondInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            let newDuration = self.viewModel.duration - repeats
            self.durationLabel.text = newDuration.durationString()
            if newDuration == -1 {
                self.reset()
            }
            repeats += 1
        })
        timer?.fire()
    }
}
