//
//  RunSummary.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 28.3.2025.
//

import RunRecorderService
import SwiftUI

@MainActor
struct RunSummary {
    var name: String = ""
    var steps: Int = 0
    var duration: TimeInterval = 0.0
    var distance: Double = 0.0
    var currentCadence: Double? = nil
    var currentPace: Double? = nil
    var averagePace: Double = 0.0
    var pace: Double? = nil
    var floorAscended: Int? = nil
    var floorDescended: Int? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var start: Date? = nil
    var end: Date? = nil
    var allLocationEvents: [LocationEvent] = []
    var allStepsEvents: [StepsEvent] = []
    
    init(){}
    
    init(with record: RunRecord) {
        name = record.name
        steps = record.steps
        duration = record.duration
        distance = record.distance
        averagePace = record.averagePace
        floorAscended = record.allFloorAscendedEvents.last?.floor
        floorDescended = record.allFloorDescendedEvents.last?.floor
        start = record.start
        end = record.end
        allLocationEvents = record.allLocationEvents
        allStepsEvents = record.allStepsEvents
    }
}
