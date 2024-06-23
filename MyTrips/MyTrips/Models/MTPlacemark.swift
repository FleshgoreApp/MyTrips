//
//  MTPlacemark.swift
//  MyTrips
//
//  Created by Anton Shvets on 22.06.2024.
//

import SwiftData
import MapKit

@Model
final class MTPlacemark {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var destination: Destination?
    
    init(name: String,
         address: String,
         latitude: Double,
         longitude: Double
    ) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
