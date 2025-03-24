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
    @FetchRequest(sortDescriptors: []) private var rawRecords: FetchedResults<RunRecordData>
    @StateObject private var viewModel = MainViewModel()
    @State private var isNewRecordViewPresented: Bool = false
    var records: [RunRecord] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.getRecordsFrom(rawRecords: rawRecords)) { record in
                    
                }
            }
            Spacer()
            Button {
                isNewRecordViewPresented = true
            } label: {
                Text("Create new record")
            }
            .navigationDestination(isPresented: $isNewRecordViewPresented) {
                RunRecordView(context: context)
            }
        }
    }
}


struct RecordsListView: View {
    @Namespace private var namespace
    let cryptos: [RunRecord]
    let selectedRecord: RunRecord
    private let gridColumns = Array(repeating: GridItem(.adaptive(minimum: 150, maximum: 175), spacing: 24), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 24) {
                ForEach(cryptos) { crypto in
                    NavigationLink {
                        Text("HERE SHOULD BE THE DETAIL")
                        .navigationTransition(.zoom(sourceID: crypto.id, in: namespace))
                    } label: {
                        Text("HERE SHOUL BE THE CELL")
                        .matchedTransitionSource(id: crypto.id, in: namespace)
                        .contextMenu {
                            Text("Historical data of 1 year")
                        } preview: {
                            //TODO: HERE is gonan be the PREVIEW
                            Text("PREVIEW")
                        }
                    }
                    .scrollTransition { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.97)
                            .blur(radius: phase == .topLeading ? 3 : 0, opaque: phase.isIdentity ? false : true)
                            .blur(radius: phase == .bottomTrailing ? 2 : 0, opaque: phase.isIdentity ? false : true)
                    }
                }
            }
            .padding([.horizontal, .top])
        }
    }
}

struct RecordCell: View {
    @Environment(\.colorScheme) private var colorScheme
    let runRecord: RunRecord

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .fill(colorScheme == .dark ? Color.white.gradient.opacity(0.25) : Color.gray.gradient.opacity(0.15))
            VStack(spacing: 4) {
                
                Divider()
                    .overlay(colorScheme == .dark ? .white.opacity(0.25) : .gray.opacity(0.25))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                Text("Last 24h:").descriptionStyle(size: 15)
                
            }
            .padding([.horizontal, .vertical], 6)
        }
        .frame(minWidth: 150, idealWidth: 175, maxWidth: 175, minHeight: 150, idealHeight: 175, maxHeight: 175, alignment: .center)
    }
}

#Preview {
    MainView()
}
