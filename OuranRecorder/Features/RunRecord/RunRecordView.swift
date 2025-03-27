//
//  RunRecordView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 24.3.2025.
//

import CoreData
import SwiftUI
import RunRecorderService

struct RunRecordView: View {
    @StateObject private var viewModel: RunRecordViewModel
    @State private var isRecordAnimating: Bool = false
    @State private var recordName: String = ""
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RunRecordViewModel(context: context))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        Group {
                            headerView
                            .padding(.bottom, -12)
                            Divider()
                            infoView
                            .frame(width: proxy.size.width)
                            .padding(.bottom, 4)
                            if !viewModel.allLocationEvents.isEmpty {
                                RecordMap(locations: viewModel.allLocationEvents.map{ $0.location })
                                    .padding(.bottom, 4)
                                    .frame(width: proxy.size.width, height: proxy.size.height * 0.5)
                                    .transition(.scale.combined(with: .blurReplace))
                            }
//                            if !viewModel.allStepsEvents.isEmpty {
                                RecordChart(
                                    stepsEvents: viewModel.allStepsEvents,
                                    title: "Current steps",
                                    height: proxy.size.height * 0.35
                                )
                                .padding(.bottom, 18)
                                .transition(.scale.combined(with: .blurReplace))
//                            }
                        }
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.97)
                                .blur(radius: phase == .topLeading ? 3 : 0, opaque: phase.isIdentity ? false : true)
                                .blur(radius: phase == .bottomTrailing ? 2 : 0, opaque: phase.isIdentity ? false : true)
                        }
                    }
                }.safeAreaInset(edge: .bottom) {
                    actionsView
                }
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            TextField(viewModel.name, text: $recordName)
            .titleStyle(size: 28)
            .onSubmit {
                viewModel.changeRecordName(with: recordName)
            }.submitLabel(.done)
            Spacer()
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(viewModel.steps, format: .number)
                    .descriptionStyle(size: 24)
                Text("steps")
                    .labelStyle(size: 12)
            }
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Run information")
                .subtitleStyle(size: 22)
                .padding(.bottom, -4)
                Group {
                    LabelWithDetailView(label: "Distance:") {
                        Text(viewModel.distance, format: .number.precision(.fractionLength(2)))
                    }
                    LabelWithDetailView(label: "Current cadence:") {
                        Text(viewModel.currentCadence, format: .number.precision(.fractionLength(2)))
                    }
                    LabelWithDetailView(label: "Current pace:") {
                        Text(viewModel.currentPace, format: .number.precision(.fractionLength(2)))
                    }
                    LabelWithDetailView(label: "Pace:") {
                        Text(viewModel.pace, format: .number.precision(.fractionLength(2)))
                    }
                    LabelWithDetailView(label: "Average pace:") {
                        Text(viewModel.averagePace, format: .number.precision(.fractionLength(2)))
                    }
                    LabelWithDetailView(label: "Floor ascended:") {
                        Text(viewModel.floorAscended, format: .number)
                    }
                    LabelWithDetailView(label: "Floor descended:") {
                        Text(viewModel.floorDescended, format: .number)
                    }
                    LabelWithDetailView(label: "Latitude:") {
                        Text(viewModel.latitude, format: .number.precision(.fractionLength(10)))
                    }
                    LabelWithDetailView(label: "Longitude:") {
                        Text(viewModel.longitude, format: .number.precision(.fractionLength(10)))
                    }
                    HStack(alignment: .lastTextBaseline, spacing: 24) {
                        if let start = viewModel.start {
                            LabelWithDetailView(label: "Start:") {
                                Text(start, format: .dateTime)
                            }
                        }
                        if let end = viewModel.end {
                            LabelWithDetailView(label: "End:") {
                                Text(end, format: .dateTime)
                            }
                            .transition(.blurReplace)
                        }
                    }
                }
                .padding(.leading, 8)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var actionsView: some View {
        switch viewModel.status {
        case .waiting:
            Button {
                viewModel.startNewRecord()
                isRecordAnimating = true
            } label: {
                Image(systemName: "record.circle")
                .font(.system(size: 36))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                    .fill(.red)
                )
            }
        case .recording:
            Button {
                viewModel.stopNewRecord()
                isRecordAnimating = false
            } label: {
                Image(systemName: "record.circle") //stop.circle
                .font(.system(size: 36))
                .padding()
                .scaleEffect(1.15)
                .symbolEffect(.bounce, isActive: isRecordAnimating)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                .fill(.red)
                )
            }
        case .stopped:
            Button {
                viewModel.saveCurrentRecord()
                isRecordAnimating = false
            } label: {
                Image(systemName: "folder.circle")
                .font(.system(size: 36))
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                .fill(.green)
                )
            }
        case .saved:
            EmptyView()
        }
    }
}
