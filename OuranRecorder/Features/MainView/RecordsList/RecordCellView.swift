//
//  RecordCellView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import RunRecorderService
import SwiftUI

struct RecordCellView: View {
    @Environment(\.colorScheme) private var colorScheme
    let record: RunRecord

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .fill(colorScheme == .dark ? Color.white.gradient.opacity(0.25) : Color.gray.gradient.opacity(0.15))
            VStack(spacing: 4) {
                titleAndStepsView
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                .overlay(colorScheme == .dark ? .white.opacity(0.25) : .gray.opacity(0.25))
                .padding(.horizontal)
                Spacer()
                distanceAndDateView
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .padding([.horizontal, .vertical], 6)
        }
        .frame(minWidth: 150, idealWidth: 175, maxWidth: 175, minHeight: 150, idealHeight: 175, maxHeight: 175, alignment: .center)
    }
    
    @ViewBuilder
    private var titleAndStepsView: some View {
        VStack(spacing: 4) {
            Text(record.name)
                .lineLimit(2)
                .titleStyle(size: 24)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(record.steps, format: .number)
                    .titleStyle(size: 18)
                Text("steps")
                    .titleStyle(size: 14)
            }
        }
    }
    
    @ViewBuilder
    private var distanceAndDateView: some View {
        VStack(spacing: 12) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(record.totalDistance, format: .number.precision(.fractionLength(1)))
                    .descriptionStyle(size: 18)
                    .lineLimit(1)
                Text("m")
                .descriptionStyle(size: 16)
            }
            Text(record.start, format: .dateTime)
                .descriptionStyle(size: 15)
        }
    }
}
