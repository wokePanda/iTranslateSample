//
//  FileManager+Helpers.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

protocol FileManagerWrapper {
    func getDocumentsDirectory() -> URL
    func getAudioFilePaths() -> [String]
    func removeFile(at url: URL) throws
}
