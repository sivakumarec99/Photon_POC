//
//  MapViewRepresentable.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//


import SwiftUI
import GoogleMaps

struct MapViewRepresentable: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    var stores: [Store] = []
    
    func makeUIView(context: Context) -> GMSMapView {
        let map = GSMService.shared.configureMap(at: coordinate, zoom: 14)
        GSMService.shared.enableUserLocation()
        GSMService.shared.showStoresOnMap(stores: stores)
        return map
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Optionally update map dynamically
    }
}