//
//  MockFileManagerWrapper.swift
//  iTranslateSample00Tests
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
@testable import iTranslateSample00

struct MockFileManagerWrapper: FileManagerWrapper {
    func removeFile(at url: URL) throws {}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getAudioFilePaths() -> [String] {
        return ["Recording 1", "Recording 2"]
    }
}
