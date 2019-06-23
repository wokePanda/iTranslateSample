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
    private let permissionWrapper: AVPermissionWrapper!
    private let fileManagerWrapper: FileManagerWrapper!
    private var recordingSession: AVAudioSession? {
        return permissionWrapper.session
    }
    private var audioRecorder: AVAudioRecorder!
    private var nameOfRecording: String {
        return "\(Constants.recordingFileName) \(lastRecordingNumber() + 1)\(Constants.recordingFileFormat)"
    }
    
    // MARK: - Public variables
    var finishRecording: ((Error?) -> Void) = { _ in }
    var createRecording: (() -> Void) = {}
    var handlerError: ((Error) -> Void) = { _ in }
    
    // MARK: - Init
    init(permissionWrapper: AVPermissionWrapper = .real(session: AVAudioSession.sharedInstance()), fileManagerWrapper: FileManagerWrapper = DeviceFileManagerWrapper()) {
        self.permissionWrapper = permissionWrapper
        self.fileManagerWrapper = fileManagerWrapper
        super.init()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        do {
            try createSession()
        } catch let error {
            handlerError(error)
        }
    }
    
    // MARK: - Private helpers
    private func createSession() throws {
        try recordingSession?.setCategory(.record, mode: .default)
        try recordingSession?.setActive(true)
    }
    
    private func startRecording() {
        let audioFilename = fileManagerWrapper.getDocumentsDirectory().appendingPathComponent(nameOfRecording)
        
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
        return fileManagerWrapper.getAudioFilePaths().last?.indexForRecordingFile() ?? 0
    }
    
    // MARK: - Public helpers
    func toggleRecording(completion handler: @escaping (RecordingStatus) -> Void) {
        if audioRecorder != nil, audioRecorder.isRecording {
            stopRecording(error: nil)
            handler(.stopped)
        } else {
            switch permissionWrapper.permission {
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
        recordingSession?.requestRecordPermission() { [weak self] _ in
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
