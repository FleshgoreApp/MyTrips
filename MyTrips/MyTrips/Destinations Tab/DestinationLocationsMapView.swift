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
    var destination: Destination
        
    var body: some View {
        VStack(spacing: .zero) {
            topView
            map
        }
        .navigationTitle("Destination")
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            if let region = destination.region {
                cameraPosititon = .region(region)
            }
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
        Map(position: $cameraPosititon) {
            ForEach(destination.placemarks) { placemark in
                Marker(coordinate: placemark.coordinate) {
                    Label(placemark.name, systemImage: "star")
                }
                .tint(.red)
            }
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor).first!
    
    return NavigationStack {
        DestinationLocationsMapView(destination: destination)
    }
}
