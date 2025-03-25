//
//  MainViewModel.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 24.3.2025.
//

import RRStorageService
import RunRecorderService
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @Published var records: [RunRecord] = []
    
    init() {}
    
    func getRecordsFrom(rawRecords: FetchedResults<RunRecordData>) -> [RunRecord] {
        Array(rawRecords).compactMap{ RunRecord.init(with: $0) }
    }
}


