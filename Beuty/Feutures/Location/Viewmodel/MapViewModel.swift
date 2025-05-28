//
//  MapViewModel.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//


import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps

final class MapViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var predictions: [GMSAutocompletePrediction] = []
    @Published var selectedAddress: String = ""
    @Published var selectedLocation: CLLocationCoordinate2D?
    
    private let placesClient = GMSPlacesClient.shared()
    
    func searchPlaces() {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.findAutocompletePredictions(fromQuery: searchText,
                                                  filter: filter,
                                                  sessionToken: nil) { [weak self] results, error in
            guard let self = self else { return }
            if let error = error {
                print("Search Error: \(error)")
                return
            }
            self.predictions = results ?? []
        }
    }
    
    func selectPlace(_ prediction: GMSAutocompletePrediction) {
        let placeID = prediction.placeID
        
        placesClient.fetchPlace(fromPlaceID: placeID,
                                placeFields: [.name, .formattedAddress, .coordinate],
                                sessionToken: nil) { [weak self] place, error in
            guard let self = self else { return }
            if let error = error {
                print("Place Fetch Error: \(error)")
                return
            }
            if let place = place {
                self.selectedAddress = place.formattedAddress ?? "Unknown"
                self.selectedLocation = place.coordinate
                GSMService.shared.configureMap(at: place.coordinate) // update map
            }
        }
    }
}
