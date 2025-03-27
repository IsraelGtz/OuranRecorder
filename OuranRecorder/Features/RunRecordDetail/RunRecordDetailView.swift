//
//  RunRecordDetailView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import RunRecorderService
import SwiftUI

struct RunRecordDetailView: View {
    let record: RunRecord
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    Group {
                        headerView
                        .padding(.bottom, -12)
                        Divider()
                        infoView
                        .padding()
                        RecordChart(stepsEvents: record.allStepsEvents)
                            .padding(.bottom, 18)
                        RecordMap(locations: record.allLocationEvents.map{ $0.location })
                            .padding(.bottom)
                            .frame(width: proxy.size.width, height: 400)
                    }
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.97)
                            .blur(radius: phase == .topLeading ? 3 : 0, opaque: phase.isIdentity ? false : true)
                            .blur(radius: phase == .bottomTrailing ? 2 : 0, opaque: phase.isIdentity ? false : true)
                    }
                }
            }
        }
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .navigationTitle(record.name)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(record.name)
            .titleStyle(size: 28)
            Spacer()
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(record.steps, format: .number)
                    .descriptionStyle(size: 24)
                Text("steps")
                    .labelStyle(size: 12)
            }
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 10) {
            LabelWithDetailView(label: "Distance:") {
                Text(record.totalDistance, format: .number.precision(.fractionLength(2)))
            }
            LabelWithDetailView(label: "Start:") {
                Text(record.start, format: .dateTime.day())
            }
            LabelWithDetailView(label: "End:") {
                Text(record.start, format: .dateTime.day())
            }
        }
    }
}

