//
//  iTranslateSample00Tests.swift
//  iTranslateSample00Tests
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import XCTest
import AVFoundation
@testable import iTranslateSample00

class iTranslateSample00Tests: XCTestCase {
    
    var viewModel: RecordingViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = RecordingViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        viewModel = nil
    }
    
    func test_requestAudioPermission_permissionsAreNotUndetermined_Successful() {
        viewModel.requestAudioPermission()
        XCTAssert(AVAudioSession.sharedInstance().recordPermission != .undetermined)
    }
    
}
