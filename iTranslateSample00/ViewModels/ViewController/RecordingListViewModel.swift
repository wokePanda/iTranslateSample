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
    private let fileManagerWrapper: FileManagerWrapper!
    private var recordings = [Recording]()
    private var player: AVAudioPlayer?
    
    // MARK: - Public Variables
    var numberOfFiles: Int { return recordings.count }
    var handlerError: ((Error) -> Void) = { _ in }
    
    // MARK: - Init
    init(fileManagerWrapper: FileManagerWrapper = DeviceFileManagerWrapper()) {
        self.fileManagerWrapper = fileManagerWrapper
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        do {
            try createSession()
            getRecordings()
        } catch let error {
            handlerError(error)
        }
    }
    
    // MARK: - Private helpers
    private func createSession() throws {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
    }
    
    private func getRecordings() {
        recordings = fileManagerWrapper.getAudioFilePaths().compactMap({ Recording.from(filePath(for: $0)) })
    }
    
    private func filePath(for name: String) -> String {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
        return "file://" + fileManagerWrapper.getDocumentsDirectory().path + "/" + encodedName
    }
    
    private func play(recording: Recording) throws {
        guard let url = URL(string: recording.path) else { return }
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
        player?.play()
    }
    
    private func remove(recording: Recording) throws {
        guard let url = URL(string: recording.path) else { throw(CustomError.invalidUrl) }
        try fileManagerWrapper.removeFile(at: url)
    }
    
    // MARK: - Public helpers
    func recordingCellViewModel(at indexPath: IndexPath) -> RecordingCellViewModel? {
        guard indexPath.row < recordings.count else { return nil }
        return RecordingCellViewModel(recording: recordings[indexPath.row])
    }
    
    func playRecording(at indexPath: IndexPath) throws {
        guard indexPath.row < recordings.count else { throw CustomError.noFileAtPath }
        try play(recording: recordings[indexPath.row])
    }
    
    func removeRecording(at indexPath: IndexPath) throws {
        guard indexPath.row < recordings.count else { throw(CustomError.noFileAtPath) }
        try remove(recording: recordings[indexPath.row])
        recordings.remove(at: indexPath.row)
    }
    
    func recordingName(at indexPath: IndexPath) -> String? {
        guard indexPath.row < recordings.count else { return nil }
        return recordings[indexPath.row].name
    }
    
    func recordingDuration(at indexPath: IndexPath) -> Int? {
        guard indexPath.row < recordings.count else { return nil }
        return recordings[indexPath.row].duration
    }
}
