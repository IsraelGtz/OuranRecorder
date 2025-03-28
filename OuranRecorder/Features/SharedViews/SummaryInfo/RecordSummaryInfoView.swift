//
//  RecordSummaryInfoView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 28.3.2025.
 
import RunRecorderService
import SwiftUI

struct RecordSummaryInfoView: View {
    let info: SummaryInfo
    
    init(with summary: RunSummary) {
        info = SummaryInfo(with: summary)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Run information")
                .subtitleStyle(size: 22)
                .padding(.bottom, -4)
                Group {
                    LabelWithDetailView(label: "Distance:") {
                        Text(info.distance, format: .number.precision(.fractionLength(2)))
                    }
                    if let currentCadence = info.currentCadence {
                        LabelWithDetailView(label: "Current cadence:") {
                            Text(currentCadence, format: .number.precision(.fractionLength(2)))
                        }
                    }
                    if let averageCadence = info.averageCadence {
                        LabelWithDetailView(label: "Average cadence:") {
                            Text(averageCadence, format: .number.precision(.fractionLength(2)))
                        }
                    }
                    if let pace = info.pace {
                        LabelWithDetailView(label: "Pace:") {
                            Text(pace, format: .number.precision(.fractionLength(2)))
                        }
                    }
                    if let currentPace = info.currentPace {
                        LabelWithDetailView(label: "Current pace:") {
                            Text(currentPace, format: .number.precision(.fractionLength(2)))
                        }
                    }
                    if let averagePace = info.averagePace {
                        LabelWithDetailView(label: "Average pace:") {
                            Text(averagePace, format: .number.precision(.fractionLength(2)))
                        }
                    }
                    if let floorAscended = info.floorAscended {
                        LabelWithDetailView(label: "Floor ascended:") {
                            Text(floorAscended, format: .number)
                        }
                    }
                    if let floorDescended = info.floorDescended {
                        LabelWithDetailView(label: "Floor descended:") {
                            Text(floorDescended, format: .number)
                        }
                    }
                    if let latitude = info.latitude {
                        LabelWithDetailView(label: "Latitude:") {
                            Text(latitude, format: .number.precision(.fractionLength(10)))
                        }
                    }
                    if let longitude = info.longitude {
                        LabelWithDetailView(label: "Longitude:") {
                            Text(longitude, format: .number.precision(.fractionLength(10)))
                        }
                    }
                    HStack(alignment: .lastTextBaseline, spacing: 24) {
                        if let start = info.start {
                            LabelWithDetailView(label: "Start:") {
                                Text(start, format: .dateTime)
                            }
                        }
                        if let end = info.end {
                            LabelWithDetailView(label: "End:") {
                                Text(end, format: .dateTime)
                            }
                            .transition(.blurReplace)
                        }
                    }
                }
                .padding(.leading, 10)
            }
            Spacer()
        }
    }
}
