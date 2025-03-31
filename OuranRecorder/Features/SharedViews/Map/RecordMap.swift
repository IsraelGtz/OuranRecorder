//
//  RecordMap.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 26.3.2025.
//

import MapKit
import SwiftUI

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
            Text("Track")
            .subtitleStyle(size: 22)
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
