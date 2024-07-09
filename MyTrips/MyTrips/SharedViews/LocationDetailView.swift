//
//  LocationDetailView.swift
//  MyTrips
//
//  Created by Anton Shvets on 24.06.2024.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    
    @State private var name = ""
    @State private var address = ""
    
    @State private var lookaroundScene: MKLookAroundScene?
    
    var isChanged: Bool {
        guard let selectedPlacemark else { return false }
        return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            dismissButton
                .padding(.bottom, 8)
                .padding(.top, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    if destination != nil {
                        nameAddressView
                    } else {
                        placemarkDescriptionView
                    }
                    
                    lookaroundSceneView
                    
                    bottomButtonsView
                }
            }
        }
        .padding(.horizontal, 16)
        .task(id: selectedPlacemark!) {
            await fetchLookAroundPreview()
        }
        .onAppear {
            if let selectedPlacemark, destination != nil {
                name = selectedPlacemark.name
                address = selectedPlacemark.address
            }
        }
    }
    
    private var dismissButton: some View {
        HStack {
            Button {
               dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var nameAddressView: some View {
        VStack {
            Group {
                TextField("Name", text: $name)
                TextField("address", text: $address, axis: .vertical)
            }
            .animation(nil, value: isChanged)
            .textFieldStyle(.roundedBorder)
            .autocorrectionDisabled()
            
            if isChanged {
                Button("Update") {
                    selectedPlacemark?.name = name
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    selectedPlacemark?.address = address
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    UIApplication.shared.endEditing()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
            }
        }
        .animation(.spring, value: isChanged)
    }
    
    private var placemarkDescriptionView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Group {
                Text(selectedPlacemark?.name ?? "Name")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(selectedPlacemark?.address ?? "Address")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var lookaroundSceneView: some View {
        if let lookaroundScene {
            LookAroundPreview(initialScene: lookaroundScene)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            ContentUnavailableView("No preview available", systemImage: "eye.slash")
        }
    }
    
    @ViewBuilder
    private var bottomButtonsView: some View {
        if let destination {
            let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
            
            Button {
                if let selectedPlacemark {
                    if selectedPlacemark.destination == nil {
                        destination.placemarks.append(selectedPlacemark)
                    } else {
                        selectedPlacemark.destination = nil
                    }
                    dismiss()
                }
            } label: {
                Label(inList ? "Remove" : "Add", systemImage: inList ? "minus.circle" : "plus.circle")
            }
            .buttonStyle(.borderedProminent)
            .tint(inList ? .red : .green)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .disabled((name.isEmpty || isChanged))
        } else {
            HStack {
                Button("Open in maps", systemImage: "map") {
                    if let selectedPlacemark {
                        let placemark = MKPlacemark(coordinate: selectedPlacemark.coordinate)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = selectedPlacemark.name
                        mapItem.openInMaps()
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                
                Spacer()
                
                Button("Show Route", systemImage: "location.north") {
                    
                }
                .fixedSize(horizontal: true, vertical: false)
                .buttonStyle(.bordered)
            }
        }
    }
    
    private func fetchLookAroundPreview() async {
        if let selectedPlacemark {
            lookaroundScene = nil
            let lookaroundRequest = MKLookAroundSceneRequest(coordinate: selectedPlacemark.coordinate)
            lookaroundScene = try? await lookaroundRequest.scene
        }
    }
}

#Preview {
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor).first!
    let selectedPlacemark = destination.placemarks.first!
    
    return LocationDetailView(
        destination: destination,
        selectedPlacemark: selectedPlacemark
    )
}
