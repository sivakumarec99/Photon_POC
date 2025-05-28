//
//  SearchableMapView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//

import SwiftUI
import CoreLocation
import GoogleMaps


// MARK: - Map View
struct SearchableMapView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var searchService = LocationSearchService()

    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var selectedAddress: String = ""
    @State private var searchText = ""
    @State private var mapType: GMSMapViewType = .normal
    @State private var mapZoom: Float = 15

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

            // Google Map View
            if let loc = selectedLocation {
                GoogleMapView(coordinate: loc, zoom: mapZoom, mapType: mapType)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding()

                HStack {
                    Button("Zoom In") { mapZoom += 1 }
                    Button("Zoom Out") { mapZoom -= 1 }
                    Button("Toggle Map Type") {
                        mapType = mapType == .normal ? .satellite : .normal
                    }
                }
                .padding(.horizontal)
            }

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
        .onAppear {
            if let loc = locationManager.currentLocation {
                selectedLocation = loc.coordinate
                searchService.reverseGeocode(location: loc) { address in
                    selectedAddress = address ?? ""
                }
            }
        }
    }

    // Map Annotation Helper
    struct MapPinItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}

struct GoogleMapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var zoom: Float
    var mapType: GMSMapViewType

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.mapType = mapType
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
        uiView.mapType = mapType
        uiView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.map = uiView
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
