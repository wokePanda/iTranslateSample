//
//  RecordingListViewController.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

final class RecordingListViewController: UIViewController, ViewModelBased {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var playView: UIView!
    @IBOutlet private weak var recordingNameLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    
    // MARK: - Variables
    var viewModel: RecordingListViewModel! {
        didSet { viewModel.handlerError = handleError }
    }
    var timer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .babyBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.sfUiTextSemibold!,
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Recordings"
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissList))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sfUiTextRegular!,
                                           NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupTableView() {
        tableView.register(RecordingTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: playView.frame.height, right: 0)
    }
    
    // MARK: - Helpers
    @objc private func dismissList() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func handleError(error: Error) {
        presentAlert(for: error)
    }
    
    private func resetPlayer() {
        playView.isHidden = true
        timer?.invalidate()
        timer = nil
        progressLabel.text = "00:00"
    }
    
    private func playRecording(at indexPath: IndexPath) {
        resetPlayer()
        do {
            try viewModel.playRecording(at: indexPath)
            playView.isHidden = false
            recordingNameLabel.text = "Now playing: \(viewModel.recordingName(at: indexPath))"
            let recordingDuration = viewModel.recordingDuration(at: indexPath)
            progressLabel.text = recordingDuration.durationString()
            var repeats = 0
            guard let oneSecondInterval = TimeInterval(exactly: 1.0) else { return }
            timer = Timer.scheduledTimer(withTimeInterval: oneSecondInterval, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                let newDuration = recordingDuration - repeats
                self.progressLabel.text = newDuration.durationString()
                if newDuration == -1 { self.resetPlayer() }
                repeats += 1
            })
            timer?.fire()
        } catch let error {
            presentAlert(for: error)
        }
    }
}

extension RecordingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFiles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecordingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let cellViewModel = viewModel.recordingCellViewModel(at: indexPath) {
            cell.viewModel = cellViewModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playRecording(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "") { [weak self] action, indexPath in
            guard let self = self else { return }
            do {
                try self.viewModel.removeRecording(at: indexPath)
                tableView.reloadData()
                self.presentAlert(with: "Success", message: "Recording has been deleted")
            } catch let error {
                self.presentAlert(for: error)
            }
        }
        if let deleteIconImage = UIImage(named: "deleteImage") {
            deleteAction.backgroundColor = UIColor(patternImage: deleteIconImage)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RECENTLY USED"
    }
}

extension RecordingListViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
