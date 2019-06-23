//
//  DeviceFileManagerWrapper.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

struct DeviceFileManagerWrapper: FileManagerWrapper {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("test")
    }
    func getAudioFilePaths() -> [String] {
        let enumerator = FileManager.default.enumerator(atPath: getDocumentsDirectory().path)
        guard let filePaths = enumerator?.allObjects as? [String] else { return [] }
        return filePaths.filter{$0.contains(".m4a") && $0.contains("Recording")}.sorted(by: { (recordingA, recordingB) -> Bool in
            return recordingA.indexForRecordingFile() < recordingB.indexForRecordingFile()
        })
    }
    func removeFile(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
}
