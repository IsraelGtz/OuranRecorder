//
//  LabelWithDetailView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 25.3.2025.
//

import SwiftUI

struct LabelWithDetailView<DetailView: View>: View {
    let label: String
    let detail: String?
    let labelSize: CGFloat?
    let detailSize: CGFloat?
    let detailColor: Color?
    let detailView: (() -> DetailView)?
    
    init(
        label: String,
        detail: String? = nil,
        labelSize: CGFloat? = nil,
        detailSize: CGFloat? = nil,
        detailColor: Color? = nil,
        detailView: (() -> DetailView)? = nil
    ) {
        self.label = label
        self.detail = detail
        self.labelSize = labelSize
        self.detailSize = detailSize
        self.detailColor = detailColor
        self.detailView = detailView
    }
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(label)
                .labelStyle(size: labelSize)
            if let detailView {
                detailView()
            } else
            if let detail {
                Text(detail)
                .descriptionStyle(size: detailSize, color: detailColor)
            } else {
                EmptyView()
            }
        }
    }
}
