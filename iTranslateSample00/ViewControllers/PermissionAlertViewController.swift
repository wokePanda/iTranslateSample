//
//  PermissionAlertViewController.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 20/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

protocol PermissionAlertDelegate: class {
    func acceptPermission(_ accept: Bool)
}

final class PermissionAlertViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var microphoneImageView: UIImageView! {
        didSet { microphoneImageView.tintColor = .fadedGray }
    }
    
    // MARK: - Constants
    private let animationDuration = 0.25
    
    // MARK: - Variables
    weak var delegate: PermissionAlertDelegate!
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fadeInBackground()
    }
    
    // MARK: - Helpers
    private func fadeInBackground() {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = .fadedBlack
        }
    }
    
    private func dismissAlert() {
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = .clear
        }) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IBActions
    @IBAction private func onAllowButtonPressed(_ sender: UIButton) {
        delegate.acceptPermission(true)
        dismissAlert()
    }
    
    @IBAction private func onLaterButtonPressed(_ sender: UIButton) {
        delegate.acceptPermission(false)
        dismissAlert()
    }
}

extension PermissionAlertViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
