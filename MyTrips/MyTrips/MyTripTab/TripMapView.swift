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
        .mapControls {
            MapUserLocationButton()
        }
    }
}

#Preview {
    TripMapView()
        .environment(LocationManager())
}
