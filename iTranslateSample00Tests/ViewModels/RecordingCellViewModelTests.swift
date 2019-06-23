//
//  RecordingCellViewModelTests.swift
//  iTranslateSample00Tests
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import XCTest
@testable import iTranslateSample00

class RecordingCellViewModelTests: XCTestCase {
    
    var recording: Recording!
    var viewModel: RecordingCellViewModel!
    
    override func setUp() {
        super.setUp()
        recording = Recording(name: "Recording 1", path: "file://documents/recording 1.m4a", duration: 4)
        viewModel = RecordingCellViewModel(recording: recording)
    }
    
    func test_returnName_successful() {
        XCTAssertEqual(viewModel.name, "Recording 1")
    }
    
    func test_returnDurationString_successful() {
        XCTAssertEqual(viewModel.durationString, "00:04")
    }
    
    func test_returnDurationIntValue_successful() {
        XCTAssertEqual(viewModel.duration, 4)
    }
}
