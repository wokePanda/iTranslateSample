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
    var finishRecording: ((Bool) -> Void) = { _ in }
    var createRecording: (() -> Void) = {}
    
    func createRecorder() throws {
        recordingSession = AVAudioSession.sharedInstance()
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)
    }
    
    private func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("Recording \(searchForRecordings()).m4a")
        
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
        } catch {
            stopRecording(success: false)
        }
    }
    
    private func stopRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        finishRecording(success)
    }
    
    private func searchForRecordings() -> Int {
        var numberOfRecordings = 0
        let enumerator = FileManager.default.enumerator(atPath: getDocumentsDirectory().path)
        guard let filePaths = enumerator?.allObjects as? [String] else { return 0 }
        let audioFilePaths = filePaths.filter{$0.contains(".m4a") && $0.contains("Recording")}
        audioFilePaths.forEach { _ in numberOfRecordings += 1 }
        return numberOfRecordings
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func toggleRecording(completion handler: @escaping (RecordingStatus) -> Void) {
        if audioRecorder != nil, audioRecorder.isRecording {
            stopRecording(success: true)
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
        if !flag { stopRecording(success: false) }
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
