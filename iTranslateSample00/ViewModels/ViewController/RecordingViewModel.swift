//
//  RecordingViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 20/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation
import AVFoundation

enum RecordingStatus {
    case recording
    case stopped
    case needPermissions
    case deniedPermissions
}

final class RecordingViewModel: NSObject, ViewModel {
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    var finishRecording: ((Error?) -> Void) = { _ in }
    var createRecording: (() -> Void) = {}
    
    func createRecorder() throws {
        recordingSession = AVAudioSession.sharedInstance()
        try recordingSession.setCategory(.record, mode: .default)
        try recordingSession.setActive(true)
    }
    
    private func startRecording() {
        let audioFilename = FileManagerHelper.getAppDirectory().appendingPathComponent("Recording \(lastRecordingNumber() + 1).m4a")
        
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
        let audioFilePaths = filePaths.filter{ $0.contains(".m4a") && $0.contains("Recording") }.sorted()
        return Int(audioFilePaths.last?.replacingOccurrences(of: "Recording ", with: "").replacingOccurrences(of: ".m4a", with: "") ?? "0") ?? 0
    }
    
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
}

extension RecordingViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag { stopRecording(error: CustomError.recordingStopped) }
    }
}

extension RecordingViewModel: PermissionAlertDelegate {
    func acceptPermission(_ accept: Bool) {
        if accept {
            recordingSession.requestRecordPermission() { [weak self] _ in
                guard let self = self else { return }
                self.startRecording()
            }
        }
    }
}
