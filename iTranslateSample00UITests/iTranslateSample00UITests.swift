//
//  iTranslateSample00UITests.swift
//  iTranslateSample00UITests
//
//  Created by Andreas Dolinsek on 13.04.16.
//  Copyright © 2016 Andreas Dolinsek. All rights reserved.
//

import XCTest

class iTranslateSample00UITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func test_recordingCreation_withGrantedPermission_succesful() {
        let app = XCUIApplication()
        app.buttons["Mic"].tap()
        wait(for: [], timeout: 2.0)
        app.buttons["Mic"].tap()
        app.alerts["Success"].buttons["OK"].tap()
    }
    
    func test_accessRecordingList_successful() {
        let app = XCUIApplication()
        app.buttons["Show Recordings"].tap()
        app.navigationBars["Recordings"].buttons["Done"].tap()
    }
}
