//
//  RecordingListViewController.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

final class RecordingListViewController: UIViewController, ViewModelBased {
    
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
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .babyBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissList))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.sfUiTextRegular!,
                                           NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Helpers
    @objc private func dismissList() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension RecordingListViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
