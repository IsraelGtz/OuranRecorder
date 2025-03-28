//
//  ContentView.swift
//  OuranRecorder
//
//  Created by Israel Gutiérrez Castillo on 23.3.2025.
//

import RunRecorderService
import RRStorageService
import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [.init(key: "start", ascending: false)]) private var rawRecords: FetchedResults<RunRecordData>
    @StateObject private var viewModel = MainViewModel()
    @State var selectedRecord: RunRecord? = nil
    @State private var isNewRecordViewPresented: Bool = false
    var records: [RunRecord] = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                RecordsListView(
                    records: viewModel.getRecordsFrom(rawRecords: rawRecords),
                    selectedRecord: $selectedRecord
                )
                .safeAreaInset(edge: .bottom) {
                    Button {
                        isNewRecordViewPresented = true
                    } label: {
                        Text("Go recording!")
                            .descriptionStyle(size: 18, color: .white)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 20,
                                    style: .continuous
                                )
                                .fill(.gray)
                            )
                    }
                    .navigationDestination(isPresented: $isNewRecordViewPresented) {
                        RunRecordView(context: context)
                    }
                    .padding(.top, 12)
                }
            }
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .navigationTitle("Ōuran Recorder")
        }
    }
}

#Preview {
    MainView()
}
