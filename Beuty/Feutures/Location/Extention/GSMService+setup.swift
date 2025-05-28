//
//  GSMService+setup.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//

import Foundation
import GoogleMaps

extension GSMService: MapService {
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String?, snippet: String?) {
        print("")
    }
    
    func configureMap(at coordinate: CLLocationCoordinate2D, zoom: Float = 15.0) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.mapView = mapView
        return mapView
    }

    func enableUserLocation() {
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
}
