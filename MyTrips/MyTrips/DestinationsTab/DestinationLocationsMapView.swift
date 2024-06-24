//
//  DestinationLocationsMapView.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//


import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<MTPlacemark> { $0.destination == nil })
    private var searchPlacemarks: [MTPlacemark]
    private var listPlacemarks: [MTPlacemark] {
        searchPlacemarks + destination.placemarks
    }
    @State private var cameraPosititon: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchText: String = ""
    @State private var selectedPlacemark: MTPlacemark?
    @FocusState private var searchFieldFocus: Bool
    
    var destination: Destination
    private let mapManager: MapManagerProtocol
    
    init(destination: Destination,
         mapManager: MapManagerProtocol = MapManager()
    ) {
        self.destination = destination
        self.mapManager = mapManager
    }
        
    var body: some View {
        VStack(spacing: .zero) {
            topView
            map
        }
        .sheet(item: $selectedPlacemark) { selectedPlacemark in
            LocationDetailView(
                destination: destination,
                selectedPlacemark: selectedPlacemark
            )
            .presentationDetents([.large])
        }
        .safeAreaInset(edge: .bottom) {
            searchView
        }
        .navigationTitle("Destination")
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            //TODO: ?
            mapManager.removeSearchResults(modelContext)
            
            if let region = destination.region {
                cameraPosititon = .region(region)
            }
        }
        .onDisappear {
            mapManager.removeSearchResults(modelContext)
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
        }
    }
    
    private var topView: some View {
        @Bindable var destination = destination
        
        return VStack(spacing: 8) {
            LabeledContent {
                TextField(
                    "Enter destination name",
                    text: $destination.name
                )
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.primary)
            } label: {
                Text("Name")
            }

            HStack {
                Text("Adjust the map to set the region for your destination.")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Set region") {
                    if let visibleRegion {
                        destination.latitude = visibleRegion.center.latitude
                        destination.longitude = visibleRegion.center.longitude
                        destination.latitudeDelta = visibleRegion.span.latitudeDelta
                        destination.longitudeDelta = visibleRegion.span.longitudeDelta
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private var map: some View {
        Map(position: $cameraPosititon, selection: $selectedPlacemark) {
            ForEach(listPlacemarks) { placemark in
                Group {
                    if placemark.destination != nil {
                        Marker(coordinate: placemark.coordinate) {
                            Label(placemark.name, systemImage: "star")
                        }
                        .tint(.yellow)
                    } else {
                        Marker(placemark.name, coordinate: placemark.coordinate)
                    }
                }
                .tag(placemark)
            }
        }
    }
    
    private var searchView: some View {
        HStack {
            TextField("Search ...", text: $searchText)
                .focused($searchFieldFocus)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .overlay(alignment: .trailing) {
                    if searchFieldFocus {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.trailing, 5)
                        }
                    }
            }
            .onSubmit {
                Task {
                    //TODO: Passing argument of non-sendable type 'ModelContext' into main actor-isolated context may introduce data races
                    await mapManager.searchPlaces(
                        modelContext,
                        searchText: searchText,
                        visibleRegion: visibleRegion
                    )
                    searchText = ""
                    cameraPosititon = .automatic
                }
            }
            
            if !searchPlacemarks.isEmpty {
                Button {
                    mapManager.removeSearchResults(modelContext)
                } label: {
                    Image(systemName: "mappin.slash.circle.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.white)
                .padding(8)
                .background(.red)
                .clipShape(.circle)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor).first!
    
    return NavigationStack {
        DestinationLocationsMapView(destination: destination)
    }
    .modelContainer(Destination.preview)
}
