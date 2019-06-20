//
//  UIViewController+Extension.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 20/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(with title: String, message: String, actionMessage: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let customAction = UIAlertAction(title: actionMessage, style: .default) { _ in
            action()
        }
        alert.addAction(customAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(for error: Error?, retryAction: (() -> Void)? = nil) {
        guard let error = error else { return }
        if let retryAction = retryAction {
            presentAlert(with: "Error", message: error.localizedDescription, actionMessage: "Retry", action: retryAction)
            return
        }
        presentAlert(with: "Error", message: error.localizedDescription)
    }
}
