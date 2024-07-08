//
//  TripMapView.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//


import SwiftUI
import MapKit
import SwiftData

struct TripMapView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var visibleRegion: MKCoordinateRegion?
    @Environment(LocationManager.self) private var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var listPlacemarks: [MTPlacemark]
    
    private let mapManager: MapManagerProtocol
    
    // Search
    @State private var searchText: String = ""
    @Query(filter: #Predicate<MTPlacemark> { $0.destination == nil })
    private var searchPlacemarks: [MTPlacemark]
    
    @State private var selectedPlacemark: MTPlacemark?
    
    init(mapManager: MapManagerProtocol = MapManager()) {
        self.mapManager = mapManager
    }
    
    var body: some View {
        map
            .sheet(item: $selectedPlacemark) { selectedPlacemark in
                
            }
            .onAppear {
                updateCameraPosition()
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .mapControls {
                MapUserLocationButton()
            }
            .safeAreaInset(edge: .bottom) {
                searchView
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
    }
    
    private var map: some View {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation()
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
    
    @MainActor
    private var searchView: some View {
        SearchView(
            searchText: $searchText,
            trailingButtonShowed: !searchPlacemarks.isEmpty,
            trailingButtonImageName: "mappin.slash",
            placeholder: "Search ...",
            onSubmit: {
                Task {
                    await mapManager.searchPlaces(
                        modelContext,
                        searchText: searchText,
                        visibleRegion: visibleRegion
                    )
                    searchText = ""
                }
            },
            onClear: {
                searchText = ""
            },
            onTrailingButtonTapped: {
                mapManager.removeSearchResults(modelContext)
            }
        )
    }
    
    private func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: .init(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

#Preview {
    TripMapView()
        .environment(LocationManager())
        .modelContainer(Destination.preview)
}
