//
//  Destination.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//


import SwiftUI
import MapKit

struct DestinationLocationsMapView: View {
    @State private var cameraPosititon: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        Map(position: $cameraPosititon) {
            Marker("Moulin Rouge", coordinate: .init(latitude: 48.884134, longitude: 2.332196))
        }
        .onAppear {
            let city = CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077)
            let citySpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let region = MKCoordinateRegion(center: city, span: citySpan)
            cameraPosititon = .region(region)
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
        }
    }
}

#Preview {
    DestinationLocationsMapView()
}
