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
    @State private var cameraPosititon: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var destination: Destination?
    
    @Query private var destinations: [Destination]
    
    var body: some View {
        Map(position: $cameraPosititon) {
            if let destination {
                ForEach(destination.placemarks) { placemark in
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name, systemImage: "star")
                    }
                    .tint(.red)
                }
            }
        }
        .onAppear {
            destination = destinations.first
            if let region = destination?.region {
                cameraPosititon = .region(region)
            }
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
        }
    }
}

#Preview {
    DestinationLocationsMapView()
        .modelContainer(Destination.preview)
}
