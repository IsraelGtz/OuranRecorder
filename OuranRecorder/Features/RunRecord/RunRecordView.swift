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
    private let areRecordActionsEnabled: Bool
    
    ///Passing a run record will show it's info
    init(
        context: NSManagedObjectContext,
        runRecord: RunRecord? = nil
    ) {
        let summary: RunSummary
        if let runRecord {
            areRecordActionsEnabled = false
            summary = RunSummary(with: runRecord)
        } else {
            areRecordActionsEnabled = true
            summary = RunSummary()
        }
        _viewModel = StateObject(wrappedValue: RunRecordViewModel(context: context, summary: summary))
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
                            RecordSummaryInfoView(with: viewModel.summary)
                            .frame(width: proxy.size.width)
                            .padding(.bottom, 4)
                            if !viewModel.summary.allLocationEvents.isEmpty {
                                RecordMap(locations: viewModel.summary.allLocationEvents.map{ $0.location })
                                    .padding(.bottom, 4)
                                    .frame(width: proxy.size.width, height: proxy.size.height * 0.5)
                                  //.transition(.scale.combined(with: .blurReplace)) //this crash the app
                            }
                            if !viewModel.summary.allStepsEvents.isEmpty {
                                RecordChart(
                                    stepsEvents: viewModel.summary.allStepsEvents,
                                    title: "Current steps",
                                    height: proxy.size.height * 0.35
                                )
                                .padding(.bottom, 18)
                                .transition(.scale.combined(with: .blurReplace))
                            }
                        }
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.97)
                                .blur(radius: phase == .topLeading ? 0.75 : 0, opaque: phase.isIdentity ? false : true)
                                .blur(radius: phase == .bottomTrailing ? 1 : 0, opaque: phase.isIdentity ? false : true)
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
            TextField(viewModel.summary.name, text: $recordName)
            .titleStyle(size: 28)
            .onSubmit {
                viewModel.changeRecordName(with: recordName)
            }.submitLabel(.done)
            Spacer()
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(viewModel.summary.steps, format: .number)
                    .descriptionStyle(size: 24)
                Text("steps")
                    .labelStyle(size: 12)
            }
        }
    }
    
    @ViewBuilder
    var actionsView: some View {
        if areRecordActionsEnabled {
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
                    Image(systemName: "record.circle")
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
}
