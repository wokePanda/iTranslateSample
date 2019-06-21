//
//  String+Extension.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

extension String {
    func filenameFromPath() -> String {
        return ((self.components(separatedBy: "/").last ?? "").components(separatedBy: ".").first ?? "").replacingOccurrences(of: "%20", with: " ")
    }
    
    func indexForRecordingFile() -> Int {
        return Int(self.replacingOccurrences(of: "Recording ", with: "").replacingOccurrences(of: ".m4a", with: "")) ?? 0
    }
}
