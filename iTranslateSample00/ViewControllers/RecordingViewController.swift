//
//  ViewController.swift
//  iTranslateSample00
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController, ViewModelBased {
    var viewModel: RecordingViewModel!
}

extension RecordingViewController: Storyboarded {
    static var storyboardName: Storyboards {
        return .main
    }
}
