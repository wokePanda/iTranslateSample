//
//  ViewController.swift
//  iTranslateSample00
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import UIKit

final class RecordingViewController: UIViewController, ViewModelBased {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var recordingButton: UIButton!
    
    // MARK: - Variables
    var viewModel: RecordingViewModel! {
        didSet {
            viewModel.createRecording = createRecording
            viewModel.finishRecording = finishRecording
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        do {
            try viewModel.createRecorder()
        } catch let error {
            presentAlert(for: error)
        }
    }
    
    // MARK: - Helpers
    private func presentPermissionAlert() {
        let alert = PermissionAlertViewController.getInstance()
        alert.delegate = viewModel
        alert.modalPresentationStyle = .overCurrentContext
        present(alert, animated: true, completion: nil)
    }
    
    private func createRecording() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recordingButton.tintColor = .red
        }
    }
    
    private func finishRecording(success: Bool) {
        self.recordingButton.tintColor = .babyBlue
        if success {
            presentAlert(with: "Success", message: "Your recording has been created!")
        } else {
            presentAlert(with: "Failure", message: "Your recording could not be saved")
        }
    }
    
    private func toggleRecording() {
        viewModel.toggleRecording { [weak self] newStatus in
            guard let self = self else { return }
            switch newStatus {
            case .stopped:
                return
            case .deniedPermissions:
                self.presentAlert(with: "Error", message: "Please allow access to microphone from settings", actionMessage: "OK") {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsUrl)
                }
            case .needPermissions:
                self.presentPermissionAlert()
            case .recording:
                self.createRecording()
            }
        }
    }
    
    private func goToRecordings() {
        let recordingListViewController = RecordingListViewController.instantiate(with: RecordingListViewModel())
        let navigationController = UINavigationController(rootViewController: recordingListViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction private func recordingToggle(_ sender: UIButton) {
        toggleRecording()
    }
    @IBAction private func goToRecordings(_ sender: UIButton) {
        goToRecordings()
    }
}

extension RecordingViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
