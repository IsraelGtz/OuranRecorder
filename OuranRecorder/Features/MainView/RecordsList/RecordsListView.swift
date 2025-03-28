//
//  RecordsListView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import RunRecorderService
import SwiftUI

struct RecordsListView: View {
    @Environment(\.managedObjectContext) private var context
    @Namespace private var namespace
    let records: [RunRecord]
    @Binding var selectedRecord: RunRecord?
    
    private let gridColumns = Array(repeating: GridItem(.adaptive(minimum: 150, maximum: 175), spacing: 24), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 24) {
                ForEach(records) { record in
                    NavigationLink {
                        RunRecordView(context: context, runRecord: record)
                        .navigationTransition(.zoom(sourceID: record.id, in: namespace))
                    } label: {
                        RecordCellView(record: record)
                        .matchedTransitionSource(id: record.id, in: namespace)
                        .contextMenu {
                            Text("Steps chart")
                        } preview: {
                            RecordChart(stepsEvents: record.allStepsEvents, version: .preview)
                                .padding()
                        }
                    }
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.97)
                            .blur(radius: phase == .topLeading ? 3 : 0, opaque: phase.isIdentity ? false : true)
                            .blur(radius: phase == .bottomTrailing ? 2 : 0, opaque: phase.isIdentity ? false : true)
                    }
                }
            }
            .padding([.horizontal, .top])
        }
    }
}
