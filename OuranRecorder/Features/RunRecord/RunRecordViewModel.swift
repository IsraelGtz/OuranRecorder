//
//  RunRecordViewModel.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 24.3.2025.
//

import Combine
import CoreData
import CoreLocation
import RunRecorderService
import RRStorageService
import SwiftUI

@MainActor
final class RunRecordViewModel: ObservableObject {
    @Published var summary: RunSummary
    @Published var status: RunRecorderServiceStatus = .waiting
    
    //Properties related to record a run
    @ObservedObject private var recorderService =  RunRecorderServiceImpl()
    private var cancellables: [AnyCancellable] = []
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext,
        summary: RunSummary
    ) {
        self.context = context
        self.summary = summary
    }
    
    func startNewRecord() {
        startObserving()
        recorderService.startNewRecord()
        withAnimation {
            summary.name = recorderService.name
            summary.start = recorderService.start
        }
    }
    
    func stopNewRecord() {
        recorderService.stopRecording()
        withAnimation {
            summary.end = recorderService.end
        }
    }
    
    func changeRecordName(with name: String) {
        recorderService.changeRecordName(with: name)
    }
    
    func saveCurrentRecord() {
        recorderService.saveCurrentRecord(using: context)
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func startObserving() {
        let lastEventCancellable = recorderService.$lastEvent.sink { [weak self] event in
           guard let self,
                 let newEvent = event
           else { return }
           self.processEvent(newEvent)
        }
        let statusCancellable = recorderService.$status.sink { [weak self] status in
            guard let self else { return }
            self.status = status
        }
        cancellables.append(contentsOf: [lastEventCancellable, statusCancellable])
    }
    
    private func processEvent(_ event: RunEvent) {
        withAnimation {
            switch event {
            case .steps(let steps, let date):
                summary.steps = steps
                summary.allStepsEvents.append(StepsEvent(steps: steps, date: date))
            case .distance(let distance, _):
                summary.distance = distance
            case .duration(let duration):
                summary.duration = duration
            case .currentCadence(let currenCadence, _):
                summary.currentCadence = currenCadence
            case .currentPace(let currentPace, _):
                summary.currentPace = currentPace
            case .pace(let pace, _):
                summary.pace = pace
            case .averagePace(let averagePace, _):
                summary.averagePace = averagePace
            case .floorAscended(let floorAscended, _):
                summary.floorAscended = floorAscended
            case .floorDescended(let floorDescended, _):
                summary.floorDescended = floorDescended
            case .location(let location, let date):
                summary.latitude = location.latitude
                summary.longitude = location.longitude
                summary.allLocationEvents.append(LocationEvent(location: location, date: date))
            }
        }
    }
}
