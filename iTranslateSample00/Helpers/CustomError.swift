//
//  CustomError.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case noFileAtPath
    case recordingStopped
    case invalidUrl
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noFileAtPath:
            return NSLocalizedString("There is no file at this path", comment: "No File Error")
        case .recordingStopped:
            return NSLocalizedString("Recording was interrupted", comment: "Recording Error")
        case .invalidUrl:
            return NSLocalizedString("File url is invalid", comment: "URL Error")
        }
    }
}
