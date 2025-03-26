//
//  RunRecord+Extensions.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import RRStorageService
import RunRecorderService
import Foundation

extension RunRecord {
    convenience init?(with data: RunRecordData) {
        guard let name = data.name,
              let start = data.start,
              let end = data.end,
              let rawEvents = data.has?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true) ]) as? [RunEventData]
        else {
            return nil
        }
        let events = rawEvents.compactMap { RunEvent(with: $0) }
        self.init(name: name, start: start, end: end, events: events)
    }
}
