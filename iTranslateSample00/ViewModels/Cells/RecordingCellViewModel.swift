//
//  RecordingCellViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

struct RecordingCellViewModel: ViewModel {
    let name: String
    let duration: String
    
    static func from(_ recording: Recording) -> RecordingCellViewModel {
        return RecordingCellViewModel(name: recording.name, duration: recording.duration.durationString())
    }
}
