//
//  SummaryInfo.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 28.3.2025.
//

import RunRecorderService
import SwiftUI

@MainActor
struct SummaryInfo {
    var distance: Double
    var duration: TimeInterval
    var currentCadence: Double? = nil
    var averageCadence: Double? = nil
    var pace: Double? = nil
    var currentPace: Double? = nil
    var averagePace: Double? = nil
    var floorAscended: Int? = nil
    var floorDescended: Int? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var start: Date? = nil
    var end: Date? = nil
    
    init(with summary: RunSummary) {
        distance = summary.distance
        duration = summary.duration
        currentCadence = summary.currentCadence
        averageCadence = summary.averagePace
        pace = summary.pace
        currentPace = summary.currentPace
        averagePace = summary.averagePace
        floorAscended = summary.floorAscended
        floorDescended = summary.floorDescended
        latitude = summary.latitude
        longitude = summary.longitude
        start = summary.start
        end = summary.end
    }
}
