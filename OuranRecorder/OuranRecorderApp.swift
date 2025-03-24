//
//  OuranRecorderApp.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 23.3.2025.
//

import SwiftUI
import RRStorageService

@main
struct OuranRecorderApp: App {
    let storageService = RRStorageService.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .environment(\.managedObjectContext, storageService.container.viewContext)
    }
}
