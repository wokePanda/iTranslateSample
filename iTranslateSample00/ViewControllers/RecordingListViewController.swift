//
//  RecordingListViewController.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import UIKit

class RecordingListViewController: UIViewController, ViewModelBased {
    var viewModel: RecordingListViewModel!
}

extension RecordingListViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
