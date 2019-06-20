//
//  ViewController.swift
//  iTranslateSample00
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController, ViewModelBased {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var recordingButton: UIButton!
    
    // MARK: - Variables
    var viewModel: RecordingViewModel!
    
    // MARK: - Helpers
    private func presentPermissionAlert() {
        let alert = PermissionAlertViewController.getInstance()
        alert.modalPresentationStyle = .overCurrentContext
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction private func recordingToggle(_ sender: UIButton) {
        presentPermissionAlert()
    }
    @IBAction private func goToRecordings(_ sender: UIButton) {}
}

extension RecordingViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
