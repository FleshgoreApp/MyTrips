//
//  Destination.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//

import SwiftData
import MapKit

@Model
final class Destination {
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    @Relationship(deleteRule: .cascade) var placemarks: [MTPlacemark] = []
    
    init(name: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         latitudeDelta: Double? = nil,
         longitudeDelta: Double? = nil
    ) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
    }
    
    var region: MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta {
            return .init(
                center: .init(latitude: latitude, longitude: longitude),
                span: .init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else {
            return nil
        }
    }
}
