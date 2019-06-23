//
//  AVPermissionHelper.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 23/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
import AVFoundation

enum AVPermissionWrapper {
    case mock(permission: AVAudioSession.RecordPermission)
    case real(session: AVAudioSession)
    
    var permission: AVAudioSession.RecordPermission {
        switch self {
        case .mock(let permission):
            return permission
        case .real(let session):
            return session.recordPermission
        }
    }
    
    var session: AVAudioSession? {
        switch self {
        case .mock:
            return nil
        case .real(let session):
            return session
        }
    }
}
