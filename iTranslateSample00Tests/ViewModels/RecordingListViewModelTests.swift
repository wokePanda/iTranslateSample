//
//  RecordingListViewModelTests.swift
//  iTranslateSample00Tests
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import XCTest
import AVFoundation
@testable import iTranslateSample00

class RecordingListViewModelTests: XCTestCase {
    
    let viewModel = RecordingListViewModel(fileManagerWrapper: MockFileManagerWrapper())
    
    func test_numberOfFiles_returns2_successFul() {
        XCTAssert(viewModel.numberOfFiles == 2)
    }
    
    func test_cellViewModel_atValidIndexPath_successful() {
        XCTAssertNotNil(viewModel.recordingCellViewModel(at: IndexPath(row: 1, section: 0)))
    }
    
    func test_cellViewModel_correctViewModelAtValidIndexPath_successful() {
        let fetchedCellViewModel = viewModel.recordingCellViewModel(at: IndexPath(row: 1, section: 0))
        let expectedCellViewModel = RecordingCellViewModel(recording: Recording(name: "Recording 2", path: "", duration: 0))
        XCTAssertEqual(fetchedCellViewModel?.name, expectedCellViewModel.name)
        XCTAssertEqual(fetchedCellViewModel?.durationString, expectedCellViewModel.durationString)
        XCTAssertEqual(fetchedCellViewModel?.duration, expectedCellViewModel.duration)
    }
    
    func test_cellViewModel_atInvalidIndexPath_fail() {
        XCTAssertNil(viewModel.recordingCellViewModel(at: IndexPath(row: 4, section: 0)))
    }
    
    func test_playRecording_atInvalidIndexPath_fail() {
        XCTAssertThrowsError(try viewModel.playRecording(at: IndexPath(row: 4, section: 0)), "") { error in
            XCTAssertEqual(error as! CustomError, CustomError.noFileAtPath)
        }
    }
    
    func test_removeRecording_atInvalidIndexPath_fail() {
        XCTAssertThrowsError(try viewModel.removeRecording(at: IndexPath(row: 4, section: 0)), "") { error in
            XCTAssertEqual(error as! CustomError, CustomError.noFileAtPath)
        }
    }
}
