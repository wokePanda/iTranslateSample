//
//  ViewModel.swift
//  iTranslateSample00
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func signalUpdate()
}

protocol ViewModelController: ViewModelDelegate {
    associatedtype ControllerViewModel
    var viewModel: ControllerViewModel { get }
}
