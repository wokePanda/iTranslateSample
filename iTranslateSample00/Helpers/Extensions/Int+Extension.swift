//
//  String+Extension.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

extension Int {
    func durationString() -> String {
        guard self > 0 else { return "00:00" }
        let minutes = self / 60
        let seconds = self % 60
        var minutesString: String {
            if minutes > 9 {
                return "\(minutes)"
            } else {
                return "0\(minutes)"
            }
        }
        var secondsString: String {
            if seconds > 9 {
                return "\(seconds)"
            } else {
                return "0\(seconds)"
            }
        }
        return "\(minutesString):\(secondsString)"
    }
}
