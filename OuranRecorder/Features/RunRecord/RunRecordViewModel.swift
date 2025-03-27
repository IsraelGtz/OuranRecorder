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
    @Published var name: String = ""
    @Published var steps: Int = 0
    @Published var duration: TimeInterval = 0.0
    @Published var distance: Double = 0.0
    @Published var currentCadence: Double = 0.0
    @Published var currentPace: Double = 0.0
    @Published var averagePace: Double = 0.0
    @Published var pace: Double = 0.0
    @Published var floorAscended: Int = 0
    @Published var floorDescended: Int = 0
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var start: Date? = nil
    @Published var end: Date? = nil
    @Published var status: RunRecorderServiceStatus = .waiting
    @Published var allLocationEvents: [LocationEvent] = []
    @Published var allStepsEvents: [StepsEvent] = []
    
    //Properties related to record a run
    @ObservedObject private var recorderService =  RunRecorderServiceImpl()
    private var cancellables: [AnyCancellable] = []
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func startNewRecord() {
        startObserving()
        recorderService.startNewRecord()
        name = recorderService.name
        start = recorderService.start
    }
    
    func stopNewRecord() {
        recorderService.stopRecording()
        withAnimation {
            end = recorderService.end
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
                self.steps = steps
                allStepsEvents.append(StepsEvent(steps: steps, date: date))
            case .distance(let distance, _):
                self.distance = distance
            case .duration(let duration):
                self.duration = duration
            case .currentCadence(let currenCadence, _):
                self.currentCadence = currenCadence
            case .currentPace(let currentPace, _):
                self.currentPace = currentPace
            case .pace(let pace, _):
                self.pace = pace
            case .averagePace(let averagePace, _):
                self.averagePace = averagePace
            case .floorAscended(let floorAscended, _):
                self.floorAscended = floorAscended
            case .floorDescended(let floorDescended, _):
                self.floorDescended = floorDescended
            case .location(let location, let date):
                self.latitude = location.latitude
                self.longitude = location.longitude
                allLocationEvents.append(LocationEvent(location: location, date: date))
            }
        }
    }
}
