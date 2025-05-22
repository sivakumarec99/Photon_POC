//
//  Product.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation

struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct Product: Codable, Identifiable {
    let id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var image: String
    var rating: Rating?
}
