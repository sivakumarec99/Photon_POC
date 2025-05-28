//
//  GSMService+StoreLocator.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//

import Foundation
import GoogleMaps

extension GSMService {
    func showStoresOnMap(stores: [Store]) {
        for store in stores {
            let marker = GMSMarker()
            marker.position = store.coordinate
            marker.title = store.name
            marker.snippet = store.address
            marker.map = mapView
        }
    }
}
struct Store {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}
