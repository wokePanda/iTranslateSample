//
//  RecordingListViewModel.swift
//  iTranslateSample00
//
//  Created by Florin Uscatu on 21/06/2019.
//  Copyright © 2019 Andreas Dolinsek. All rights reserved.
//

import Foundation

final class RecordingListViewModel: ViewModel {
    
    // MARK: - Private Variables
    private var audioFilePaths = [String]()
    
    // MARK: - Public Variables
    var numberOfFiles: Int { return audioFilePaths.count }
    
    // MARK: - Init
    init() {
        getRecordings()
    }
    
    // MARK: - Helpers
    private func getRecordings() {
        let enumerator = FileManager.default.enumerator(atPath: getDocumentsDirectory().relativeString)
        guard let filePaths = enumerator?.allObjects as? [String] else { return }
        audioFilePaths = filePaths.filter{$0.contains(".m4a") && $0.contains("recording")}
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
