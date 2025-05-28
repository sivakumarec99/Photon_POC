//
//  LocationManager.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 28/05/25.
//


import Foundation
import CoreLocation
import Combine
import MapKit

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

// MARK: - Location Search Service
class LocationSearchService: NSObject, ObservableObject {
    @Published var searchResults: [MKMapItem] = []

    func searchPlaces(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        MKLocalSearch(request: request).start { [weak self] response, _ in
            if let mapItems = response?.mapItems {
                DispatchQueue.main.async {
                    self?.searchResults = mapItems
                }
            }
        }
    }

    func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            completion(placemarks?.first?.formattedAddress)
        }
    }
}

extension CLPlacemark {
    var formattedAddress: String {
        [
            name,
            locality,
            administrativeArea,
            postalCode,
            country
        ].compactMap { $0 }.joined(separator: ", ")
    }
}
