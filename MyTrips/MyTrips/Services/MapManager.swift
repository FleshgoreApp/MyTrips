//
//  MapManager.swift
//  MyTrips
//
//  Created by Anton Shvets on 24.06.2024.
//

import MapKit
import SwiftData

protocol MapManagerProtocol {
    @MainActor func searchPlaces(_ modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async
    func removeSearchResults(_ modelContext: ModelContext)
}

struct MapManager: MapManagerProtocol {
    
    @MainActor
    func searchPlaces(_ modelContext: ModelContext, searchText: String, visibleRegion: MKCoordinateRegion?) async {
        
        removeSearchResults(modelContext)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        if let visibleRegion {
            request.region = visibleRegion
        }
        let searchItems = try? await MKLocalSearch(request: request).start()
        (searchItems?.mapItems ?? []).forEach { mapItem in
            let mtPlacemark = MTPlacemark(
                name: mapItem.placemark.name ?? "",
                address: mapItem.placemark.title ?? "",
                latitude: mapItem.placemark.coordinate.latitude,
                longitude: mapItem.placemark.coordinate.longitude
            )
            modelContext.insert(mtPlacemark)
        }
    }
    
    func removeSearchResults(_ modelContext: ModelContext) {
        let searchPredicate = #Predicate<MTPlacemark> { $0.destination == nil }
        try? modelContext.delete(model: MTPlacemark.self, where: searchPredicate)
    }
}
