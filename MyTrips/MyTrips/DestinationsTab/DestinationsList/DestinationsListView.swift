//
//  DestinationsListView.swift
//  MyTrips
//
//  Created by Anton Shvets on 23.06.2024.
//

import SwiftUI
import SwiftData

struct DestinationsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    @State private var newDestination = false
    @State private var destinationName = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty {
                    listView
                } else {
                    unavailableView
                }
            }
            .navigationTitle("My Destinations")
            .toolbar {
                addButton
            }
        }
    }
    
    private var addButton: some View {
        Button {
            newDestination.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .alert("Enter Destination Name", isPresented: $newDestination) {
            alertLabel
        } message: {
            Text("Create a new destination")
        }
    }
    
    private var listView: some View {
        List(destinations) { destination in
            NavigationLink(value: destination) {
                DestinationsListCell(destination: destination)
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    modelContext.delete(destination)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .navigationDestination(for: Destination.self) { destination in
            DestinationLocationsMapView(destination: destination)
        }
    }
    
    private var unavailableView: some View {
        ContentUnavailableView(
            "No Destinations",
            systemImage: "globe.desk",
            description: Text("You have dont set up any destinations yet. Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to begin")
        )
    }
    
    private var alertLabel: some View {
        Group {
            TextField("Enter destination name", text: $destinationName)
                .autocorrectionDisabled()
            Button("Ok") {
                if !destinationName.isEmpty {
                    let name = destinationName
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    let destination = Destination(name: name)
                    modelContext.insert(destination)
                    destinationName = ""
                    path.append(destination)
                }
            }
            Button("cancel", role: .cancel) {}
        }
    }
}

#Preview {
    DestinationsListView()
        .modelContainer(Destination.preview)
}
