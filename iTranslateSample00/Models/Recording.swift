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
    
    static func from(_ stringPath: String) -> Recording {
        let asset = AVURLAsset(url: URL(fileURLWithPath: stringPath))
        let audioDuration = asset.duration
        let audioDurationSeconds = Int(CMTimeGetSeconds(audioDuration))
        return Recording(name: (stringPath.components(separatedBy: "/").last ?? "").components(separatedBy: ".").first ?? "",
                         path: stringPath,
                         duration: audioDurationSeconds)
    }
}
