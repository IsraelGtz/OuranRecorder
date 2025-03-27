//
//  RecordChart.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 26.3.2025.
//

import SwiftUI
import Charts
import RunRecorderService

enum RecordChartVersion {
    case normal
    case preview
}

struct RecordChart: View {
    let stepsEvents: [StepsEvent]
    let version: RecordChartVersion
    let title: String?
    let height: CGFloat
    
    init(
        stepsEvents: [StepsEvent],
        version: RecordChartVersion = .normal,
        title: String? = nil,
        height: CGFloat? = nil
    ) {
        self.stepsEvents = stepsEvents
        self.version = version
        self.title = title
        self.height = height ?? 225
    }
    
    private var marks: [StepsMark] {
        stepsEvents.map { StepsMark(with: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                .subtitleStyle(size: 22)
                .padding(.bottom, -4)
            }
            Chart {
                ForEach(marks) { mark in
                    LineMark(
                        x: .value("Date", mark.date),
                        y: .value("Price", mark.value)
                    )
                }
            }
            .padding()
            .padding(.top, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                .fill(.gray.gradient.opacity(0.1))
            )
            .if(version == .normal, transform: { view in
                view.frame(height: height)
            })
            .if(version == .preview, transform: { view in
                view.frame(minWidth: 300, idealHeight: 225)
            })
        }
    }
}

struct StepsMark: Identifiable {
    var id = UUID()
    var value: Int
    var date: Date

    init(with data: StepsEvent) {
        value = data.steps
        date = data.date
    }
}

struct Mark: Identifiable {
    var id = UUID()
    var value: Double
    var date: Date
    
    init(value: Double, date: Date) {
        self.value = value
        self.date = date
    }
}
