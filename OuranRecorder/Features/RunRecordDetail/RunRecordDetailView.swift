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
        VStack(spacing: 10) {
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

import MapKit

struct RecordMap: View {
    let locations: [CLLocationCoordinate2D]
    private var points: [MKMapPoint] {
        locations.map { MKMapPoint($0) }
    }
    
    private var initialPosition: MapCameraPosition {
        guard let initialLocation = locations.first else {
            return .automatic
        }
        let camera = MapCamera(centerCoordinate: initialLocation, distance: 100)
        return MapCameraPosition.camera(camera)
    }

    var body: some View {
            VStack(alignment: .leading) {
                Text("Path followed")
                    .subtitleStyle(size: 24)
                .padding(.bottom, -4)
                
                Map(initialPosition: initialPosition) {
                    MapPolyline(
                        points: points,
                        contourStyle: .geodesic
                    )
                    .stroke(.blue, lineWidth: 20)
                }
                .mapStyle(.hybrid)
                .mapControls {
                    MapScaleView()
                    MapCompass()
                    MapUserLocationButton()
                }
 
                .mask {
                    RoundedRectangle(cornerRadius: 25)
                }
            }
    }
}

import Charts

enum RecordChartVersion {
    case normal
    case preview
}

struct RecordChart: View {
    let stepsEvents: [StepsEvent]
    let version: RecordChartVersion
    
    init(stepsEvents: [StepsEvent], version: RecordChartVersion = .normal) {
        self.stepsEvents = stepsEvents
        self.version = version
    }
    
    private var marks: [StepsMark] {
        stepsEvents.map { StepsMark(with: $0) }
    }
    
    var body: some View {
        Chart {
            ForEach(marks) { mark in
                LineMark(
                    x: .value("Date", mark.date),
                    y: .value("Price", mark.value)
                )
            }
        }
        .if(version == .normal, transform: { view in
            view.frame(height: 225)
        })
        .if(version == .preview, transform: { view in
            view.frame(minWidth: 300, idealHeight: 225)
        })
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
