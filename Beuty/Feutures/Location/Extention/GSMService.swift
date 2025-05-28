//
//  GSMService.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//


import Foundation
import GoogleMaps

final class GSMService {
    static let shared = GSMService()
    private init() {}
    
    var mapView: GMSMapView?
}