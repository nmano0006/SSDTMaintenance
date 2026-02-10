//
//  ContentView.swift
//  SSDTMaintenance
//
//  Modern Root View
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

    @State private var outputFolder: URL?
    @State private var showFolderPicker = false
    @State private var statusMessage = "No output folder selected"

    var body: some View {
        NavigationView {
            ZStack {
                // Modern window background
                Color(NSColor.windowBackgroundColor)
                    .ignoresSafeArea()

                TabView {

                    SSDTGeneratorView(
                        outputFolder: $outputFolder,
                        statusMessage: $statusMessage
                    )
                    .tabItem {
                        Label("Generator", systemImage: "gearshape.fill")
                    }

                    DeveloperInfoView()
                        .tabItem {
                            Label("About", systemImage: "info.circle.fill")
                        }
                }
                .padding()
            }
        }
        .frame(minWidth: 960, minHeight: 680)
        .toolbar {

            ToolbarItem(placement: .primaryAction) {
                Button {
                    showFolderPicker = true
                } label: {
                    Label("Output Folder", systemImage: "folder.fill")
                }
            }

            ToolbarItem(placement: .status) {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .fileImporter(
            isPresented: $showFolderPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }

                // REQUIRED for sandbox
                _ = url.startAccessingSecurityScopedResource()

                do {
                    if !FileManager.default.fileExists(atPath: url.path) {
                        try FileManager.default.createDirectory(
                            at: url,
                            withIntermediateDirectories: true
                        )
                    }
                    outputFolder = url
                    statusMessage = "Output: \(url.path)"
                } catch {
                    statusMessage = "❌ Cannot use folder"
                }

            case .failure(let error):
                statusMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    ContentView()
}
