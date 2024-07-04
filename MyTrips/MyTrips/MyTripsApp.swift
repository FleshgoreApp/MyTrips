//
//  MyTripsApp.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//


import SwiftUI
import SwiftData

@main
struct MyTripsApp: App {
    @State private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
            } else {
                LocationDeniedView()
            }
        }
        .modelContainer(for: Destination.self)
        .environment(locationManager)
    }
}
