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

class RecordingViewModelTests: XCTestCase {
    
    func test_toggleRecording_permissionsAreUndetermined_Successfull() {
        let permissionWrapper: AVPermissionWrapper = .mock(permission: .undetermined)
        let viewModel = RecordingViewModel(permissionWrapper: permissionWrapper)
        viewModel.toggleRecording { status in
            XCTAssert(status == .needPermissions)
        }
    }
    
    func test_toggleRecording_permissionsAreDenied_Fail() {
        let permissionWrapper: AVPermissionWrapper = .mock(permission: .denied)
        let viewModel = RecordingViewModel(permissionWrapper: permissionWrapper)
        viewModel.toggleRecording { status in
            XCTAssertFalse(status == .recording)
        }
    }
    
}
