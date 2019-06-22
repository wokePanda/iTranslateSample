//
//  RecordingViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 20/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
import AVFoundation

final class RecordingViewModel: NSObject, ViewModel {
    
    // MARK: - Private variables
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var nameOfRecording: String {
        return "\(Constants.recordingFileName) \(lastRecordingNumber() + 1)\(Constants.recordingFileFormat)"
    }
    
    // MARK: - Public variables
    var finishRecording: ((Error?) -> Void) = { _ in }
    var createRecording: (() -> Void) = {}
    var handlerError: ((Error) -> Void) = { _ in }
    
    override init() {
        super.init()
        do {
            try createRecorder()
        } catch let error {
            handlerError(error)
        }
    }
    
    // MARK: - Private helpers
    private func createRecorder() throws {
        recordingSession = AVAudioSession.sharedInstance()
        try recordingSession.setCategory(.record, mode: .default)
        try recordingSession.setActive(true)
    }
    
    private func startRecording() {
        let audioFilename = FileManagerHelper.getAppDirectory().appendingPathComponent(nameOfRecording)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            createRecording()
        } catch let error {
            stopRecording(error: error)
        }
    }
    
    private func stopRecording(error: Error?) {
        audioRecorder.stop()
        audioRecorder = nil
        finishRecording(error)
    }
    
    private func lastRecordingNumber() -> Int {
        let enumerator = FileManager.default.enumerator(atPath: FileManagerHelper.getAppDirectory().path)
        guard let filePaths = enumerator?.allObjects as? [String] else { return 0 }
        let audioFilePaths = filePaths.filter{ $0.contains(Constants.recordingFileFormat) && $0.contains(Constants.recordingFileName) }.sorted()
        guard let lastAudioFile = audioFilePaths.last else { return 0 }
        return lastAudioFile.indexForRecordingFile()
    }
    
    // MARK: - Public helpers
    func toggleRecording(completion handler: @escaping (RecordingStatus) -> Void) {
        if audioRecorder != nil, audioRecorder.isRecording {
            stopRecording(error: nil)
            handler(.stopped)
        } else {
            switch recordingSession.recordPermission {
            case .denied: handler(.deniedPermissions)
            case .undetermined: handler(.needPermissions)
            case .granted:
                startRecording()
                handler(.recording)
            @unknown default: fatalError()
            }
        }
    }
    
    func requestAudioPermission() {
        recordingSession.requestRecordPermission() { [weak self] _ in
            guard let self = self else { return }
            self.startRecording()
        }
    }
}

extension RecordingViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag { stopRecording(error: CustomError.recordingStopped) }
    }
}
