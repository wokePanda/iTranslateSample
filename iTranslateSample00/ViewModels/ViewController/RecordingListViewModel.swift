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
    
    // MARK: - Private helpers
    private func getRecordings() {
        let enumerator = FileManager.default.enumerator(atPath: FileManagerHelper.getAppDirectory().path)
        guard let filePaths = enumerator?.allObjects as? [String] else { return }
        let audioFilePaths = filePaths.filter{$0.contains(".m4a") && $0.contains("Recording")}
        recordings = audioFilePaths.compactMap({ Recording.from(filePath(for: $0)) }).sorted(by: { (recordingA, recordingB) -> Bool in
            return recordingA.name < recordingB.name
        })
    }
    
    private func filePath(for name: String) -> String {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
        return "file://" + FileManagerHelper.getAppDirectory().path + "/" + encodedName
    }
    
    // MARK: - Public helpers
    func recordingCellViewModel(at indexPath: IndexPath) -> RecordingCellViewModel? {
        guard indexPath.row < recordings.count else { return nil }
        return RecordingCellViewModel.from(recordings[indexPath.row])
    }
    
    func playRecording(at indexPath: IndexPath) {
        let recording = recordings[indexPath.row]
        do {
            guard let url = URL(string: recording.path) else { return }
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeRecording(at indexPath: IndexPath, completion handler: @escaping (Error?) -> Void) {
        guard indexPath.row < recordings.count else {
            handler(CustomError.noFileAtPath)
            return
        }
        let recording = recordings[indexPath.row]
        let fileManager = FileManager.default
        do {
            guard let url = URL(string: recording.path) else {
                handler(CustomError.noFileAtPath)
                return
            }
            recordings.remove(at: indexPath.row)
            try fileManager.removeItem(at: url)
            handler(nil)
        } catch let error {
            handler(error)
        }
    }
}
