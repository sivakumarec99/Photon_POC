//
//  MapService.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//
import SwiftUI
import GoogleMaps

protocol MapService {
    func configureMap(at coordinate: CLLocationCoordinate2D, zoom: Float) -> GMSMapView
    func enableUserLocation()
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String?, snippet: String?)
    func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
}
