//
//  DestinationsListCell.swift
//  MyTrips
//
//  Created by Anton Shvets on 23.06.2024.
//
// "^[\(destination.placemarks.count) location](inflect: true)"
// https://www.swiftjectivec.com/morphology-in-ios-with-automatic-grammar-agreement/

import SwiftUI
import SwiftData

struct DestinationsListCell: View {
    let destination: Destination
    
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.accent)
            VStack(alignment: .leading) {
                Text(destination.name)
                Text("^[\(destination.placemarks.count) location](inflect: true)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor).first!
    
    return DestinationsListCell(destination: destination)
}
