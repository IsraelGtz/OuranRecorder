//
//  ContentView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 23.3.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewRunViewModel()
    
    var body: some View {
        VStack {
            
            HStack(spacing: 2) {
                Text("Time:")
                Text(viewModel.duration, format: .number.precision(.fractionLength(0)))
            }
            
            HStack(spacing: 2) {
                Text("Steps:")
                Text(viewModel.steps, format: .number)
            }
            
            HStack(spacing: 2) {
                Text("Latitude:")
                Text(viewModel.latitude, format: .number.precision(.fractionLength(10)))
            }
            
            HStack(spacing: 2) {
                Text("Longitude:")
                Text(viewModel.latitude, format: .number.precision(.fractionLength(10)))
            }
            
            Spacer()
            
            if viewModel.isRecording {
                Button {
                    viewModel.stopNewRecord()
                } label: {
                    Text("Stop recording")
                }
            } else {
                Button {
                    viewModel.startNewRecord()
                } label: {
                    Text("Start new record")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}



import Combine
import CoreLocation
import RunRecorderService

@MainActor
final class NewRunViewModel: ObservableObject {
    @Published var steps: Int = 0
    @Published var duration: TimeInterval = 0.0
    @Published var distance: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var isRecording: Bool = false
    
    @ObservedObject private var recorderService = RunRecorderServiceImpl()
    private var cancellables: [AnyCancellable] = []
    
    init() {}
    
    func startNewRecord() {
        startObserving()
        recorderService.startRecordingNewRun()
    }
    
    func stopNewRecord() {
        recorderService.stopCurrentRecord()
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
