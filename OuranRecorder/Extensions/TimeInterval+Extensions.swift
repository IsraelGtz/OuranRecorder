//
//  Untitled.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 31.3.2025.
//

import Foundation

extension TimeInterval {
    private static let formatter: DateComponentsFormatter = {
         let formatter = DateComponentsFormatter()
         formatter.allowedUnits = [.hour, .minute, .second]
         formatter.unitsStyle = .positional
         formatter.zeroFormattingBehavior = .pad
 
         return formatter
     }()
    
    static func durationString(from totalSeconds: TimeInterval) -> String {
        formatter.string(from: totalSeconds) ?? "00:00:00"
    }
}

