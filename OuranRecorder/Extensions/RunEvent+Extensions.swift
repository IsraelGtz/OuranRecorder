//
//  File.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import CoreLocation
import RRStorageService
import RunRecorderService

extension RunEvent {
    init?(with data: RunEventData) {
        switch data.type {
        case "currentCadence":
            guard let cadence = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.currentCadence(cadence, date)
        case "currentPace":
            guard let pace = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.currentPace(pace, date)
        case "distance":
            guard let distance = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.distance(distance, date)
        case "duration":
            guard let duration = data.data
            else { return nil }
            self = RunEvent.duration(duration)
        case "steps":
            guard let stepsDouble = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.steps(Int(stepsDouble), date)
        case "pace":
            guard let pace = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.pace(pace, date)
        case "averagePace":
            guard let averagePace = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.averagePace(averagePace, date)
        case "floorAscended":
            guard let floorAscended = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.floorAscended(Int(floorAscended), date)
        case "floorDescended":
            guard let floorDescended = data.data,
                  let date = data.date
            else { return nil }
            self = RunEvent.floorDescended(Int(floorDescended), date)
        case "location":
            guard let latitude = data.latitude,
                  let longitude = data.longitude,
                  let date = data.date
            else { return nil }
            self = RunEvent.location(
                CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: latitude), longitude: CLLocationDegrees(floatLiteral: longitude)),
                date
            )
        default:
            return nil
        }
    }
}
