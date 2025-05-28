//
//  GSMService+Search.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//

import Foundation
import GooglePlaces

extension GSMService {
    func searchPlaces(query: String, completion: @escaping ([GMSAutocompletePrediction]) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment

        let placesClient = GMSPlacesClient.shared()
        placesClient.findAutocompletePredictions(fromQuery: query,
                                                  filter: filter,
                                                  sessionToken: nil) { results, error in
            if let error = error {
                print("Search Error: \(error)")
                completion([])
                return
            }

            completion(results ?? [])
        }
    }
}

