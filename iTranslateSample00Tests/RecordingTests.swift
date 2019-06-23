//
//  RecordingTests.swift
//  iTranslateSample00Tests
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import XCTest
@testable import iTranslateSample00

class RecordingTests: XCTestCase {

    func test_recordingCreation_withInvalidUrl_fail() {
        XCTAssertNil(Recording.from(""))
    }
}
