//
//  SearchableMapView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//

import SwiftUI
import CoreLocation
import _MapKit_SwiftUI


// MARK: - Map View
struct SearchableMapView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var searchService = LocationSearchService()

    @State private var region = MKCoordinateRegion()
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var selectedAddress: String = ""
    @State private var searchText = ""

    var body: some View {
        VStack {
            // Search Bar
            TextField("🔍 Search a place", text: $searchText, onCommit: {
                searchService.searchPlaces(query: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            // Search Results
            if !searchService.searchResults.isEmpty {
                List(searchService.searchResults, id: \.self) { item in
                    Button {
                        let loc = item.placemark.coordinate
                        selectedLocation = loc
                        region.center = loc
                        searchService.reverseGeocode(location: item.placemark.location!) { address in
                            selectedAddress = address ?? ""
                        }
                        searchService.searchResults = []
                        searchText = ""
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "")
                            Text(item.placemark.formattedAddress)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 200)
            }

            // Map
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: selectedLocation.map { [MapPinItem(coordinate: $0)] } ?? []) { item in
                MapMarker(coordinate: item.coordinate, tint: .blue)
            }
            .onAppear {
                if let loc = locationManager.currentLocation {
                    region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    selectedLocation = loc.coordinate
                    searchService.reverseGeocode(location: loc) { address in
                        selectedAddress = address ?? ""
                    }
                }
            }
            .frame(height: 300)
            .cornerRadius(12)
            .padding()

            // Selected Address
            if !selectedAddress.isEmpty {
                Text("📍 Selected Address:")
                    .font(.headline)
                    .padding(.top)
                Text(selectedAddress)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Location Picker")
        .padding()
    }

    // Map Annotation Helper
    struct MapPinItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}



// MARK: - Preview
struct SearchableMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchableMapView()
        }
    }
}
