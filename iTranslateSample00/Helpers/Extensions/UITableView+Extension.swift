//
//  UITableView+Extension.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 20/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type, hasNib: Bool = true) {
        if hasNib {
            let bundle = Bundle(for: T.self)
            let nib = UINib(nibName: T.nibName, bundle: bundle)
            register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Not able to deque a cell")
        }
        return cell
    }
}
