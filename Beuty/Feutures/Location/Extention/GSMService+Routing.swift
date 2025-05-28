//
//  GSMService+Routing.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//

import Foundation
import GoogleMaps

extension GSMService {
    func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        path.add(from)
        path.add(to)

        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .systemBlue
        polyline.strokeWidth = 5.0
        polyline.map = mapView
    }
}
