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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if rawRecords.isEmpty {
                    noRecordsView
                } else {
                    recordsView
                }
            }
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .navigationTitle("Ōuran Recorder")
        }
    }
    
    @ViewBuilder
    private var noRecordsView: some View {
        VStack(alignment: .center, spacing: 6) {
            Spacer()
            Text("There are not records to display")
            Text("Please start recording one! 🤘")
            Spacer()
        }
        .subtitleStyle(size: 18)
        .safeAreaInset(edge: .bottom) {
            recordButton
        }
    }
    
    @ViewBuilder
    private var recordsView: some View {
        RecordsListView(
            records: viewModel.getRecordsFrom(rawRecords: rawRecords),
            selectedRecord: $selectedRecord
        )
        .safeAreaInset(edge: .bottom) {
            recordButton
        }
    }
    
    @ViewBuilder
    private var recordButton: some View {
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

#Preview {
    MainView()
}
