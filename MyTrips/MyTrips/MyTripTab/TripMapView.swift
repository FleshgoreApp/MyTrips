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
    @Environment(LocationManager.self) private var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var listPlacemarks: [MTPlacemark]
    
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            ForEach(listPlacemarks) { placemark in
                Marker(coordinate: placemark.coordinate) {
                    Label(placemark.name, systemImage: "star")
                }
                .tint(.yellow)
            }
        }
        .onAppear {
            updateCameraPosition()
        }
        .mapControls {
            MapUserLocationButton()
        }
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
}
