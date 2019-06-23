//
//  MockFileManagerWrapper.swift
//  iTranslateSample00Tests
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
@testable import iTranslateSample00

class MockFileManagerWrapper: FileManagerWrapper {
    func removeFile(at url: URL) throws {}
    
    func getDocumentsDirectory() -> URL {
        let bundlePath = Bundle(for: type(of: self)).bundlePath
        return URL(string: bundlePath)!
    }
    
    func getAudioFilePaths() -> [String] {
        return ["Recording 1.m4a", "Recording 2.m4a"]
    }
}
