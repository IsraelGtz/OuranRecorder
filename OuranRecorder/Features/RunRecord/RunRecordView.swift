//
//  RunRecordView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 24.3.2025.
//

import CoreData
import SwiftUI

struct RunRecordView: View {
    @StateObject private var viewModel: RunRecordViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RunRecordViewModel(context: context) )
    }
    
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
                HStack(spacing: 24) {
                    Button {
                        viewModel.startNewRecord()
                    } label: {
                        Text("Start new record")
                    }
                    Button {
                        viewModel.saveCurrentRecord()
                    } label: {
                        Text("Save current recording")
                    }
                }
            }
        }
        .padding()
    }
}
