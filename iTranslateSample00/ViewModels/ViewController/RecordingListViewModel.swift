//
//  RecordingListViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
import AVFoundation

final class RecordingListViewModel: ViewModel {
    
    // MARK: - Private Variables
    private var recordings = [Recording]()
    private var player: AVAudioPlayer?
    
    // MARK: - Public Variables
    var numberOfFiles: Int { return recordings.count }
    
    // MARK: - Init
    init() {
        getRecordings()
        
    }
    
    // MARK: - Helpers
    private func getRecordings() {
        let enumerator = FileManager.default.enumerator(atPath: getDocumentsDirectory().path)
        guard let filePaths = enumerator?.allObjects as? [String] else { return }
        let audioFilePaths = filePaths.filter{$0.contains(".m4a") && $0.contains("Recording")}
        recordings = audioFilePaths.map({ Recording.from($0) }).sorted(by: { (recordingA, recordingB) -> Bool in
            return recordingA.name < recordingB.name
        })
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func recordingCellViewModel(at indexPath: IndexPath) -> RecordingCellViewModel? {
        guard indexPath.row < recordings.count else { return nil }
        return RecordingCellViewModel.from(recordings[indexPath.row])
    }
    
    func playRecording(at indexPath: IndexPath) {
        let recording = recordings[indexPath.row]
        do {
            guard let url = URL(string: ("file://" + getDocumentsDirectory().path + "/" + recording.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)) else { return }
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
