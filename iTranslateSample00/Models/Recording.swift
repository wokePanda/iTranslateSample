//
//  Recording.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
import AVFoundation

struct Recording {
    let name: String
    let path: String
    let duration: Int
    
    static func from(_ stringPath: String) -> Recording? {
        guard let url = URL(string: stringPath) else { return nil }
        let asset = AVURLAsset(url: url)
        let audioDuration = asset.duration
        let audioDurationSeconds = Double(CMTimeGetSeconds(audioDuration))
        let name = ((stringPath.components(separatedBy: "/").last ?? "").components(separatedBy: ".").first ?? "").replacingOccurrences(of: "%20", with: " ")
        return Recording(name: name,
                         path: stringPath,
                         duration: Int(audioDurationSeconds))
    }
}
