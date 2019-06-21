//
//  RecordingCellViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

struct RecordingCellViewModel: ViewModel {
    private let recording: Recording!
    
    var name: String { return recording.name }
    var durationString: String { return recording.duration.durationString() }
    var duration: Int { return recording.duration }
    
    init(recording: Recording) {
        self.recording = recording
    }
}
