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
    
    // MARK: - Variables
    var viewModel: RecordingListViewModel!
    
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
    }
    
    // MARK: - Helpers
    @objc private func dismissList() {
        navigationController?.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.visibleCells.forEach { cell in
            guard let cell = cell as? RecordingTableViewCell else { return }
            cell.reset()
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.playRecording(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "") { [weak self] action, indexPath in
            guard let self = self else { return }
            self.viewModel.removeRecording(at: indexPath, completion: { error in
                if let error = error {
                    self.presentAlert(for: error)
                    return
                }
                tableView.reloadData()
                self.presentAlert(with: "Success", message: "Recording has been deleted")
            })
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
