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
    @Published var steps: Int = 0
    @Published var duration: TimeInterval = 0.0
    @Published var distance: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var isRecording: Bool = false
    
    @ObservedObject private var recorderService =  RunRecorderServiceImpl()
    private var cancellables: [AnyCancellable] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func startNewRecord() {
        startObserving()
        recorderService.startRecordingNewRun()
    }
    
    func stopNewRecord() {
        recorderService.stopCurrentRecord()
    }
    
    func saveCurrentRecord() {
        recorderService.saveCurrentRecord(using: context)
    }
    
    private func startObserving() {
        let lastEventCancellable = recorderService.$lastEvent.sink { [weak self] event in
           guard let self,
                 let newEvent = event
           else { return }
           self.processEvent(newEvent)
        }
        let isRecordingCancellable = recorderService.$isRecording.sink { [weak self] isRecording in
            guard let self else { return }
            self.isRecording = isRecording
        }
        
        cancellables.append(contentsOf: [lastEventCancellable, isRecordingCancellable])
    }
    
    private func processEvent(_ event: RunEvent) {
        switch event {
        case .steps(let steps, _):
            self.steps = steps
        case .distance(let distance, _):
            self.distance = distance
        case .duration(let duration):
            self.duration = duration
        case .location(let location, _):
            self.latitude = location.latitude
            self.longitude = location.longitude
        default:
            break
            
//        Missing
//        case .currentCadence(let double, let date),
//        case .currentPace(let double, let date),
//        case .pace(let double, let date),
//        case .averagePace(let double, let date),
//        case .floorAscended(let int, let date),
//        case .floorDescended(let int, let date):
        }
    }
    
}
