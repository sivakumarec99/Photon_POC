//
//  OfferProducts.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUICore

struct OfferProduct: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let discount: Int
    let originalPrice: Double
    let discountedPrice: Double
    let gradientColors: [Color]
}

let mockOffers: [OfferProduct] = [
    OfferProduct(
        name: "Vitamin C Serum",
        imageName: "serum",
        discount: 30,
        originalPrice: 25.0,
        discountedPrice: 17.5,
        gradientColors: [Color.pink, Color.orange]
    ),
    OfferProduct(
        name: "Moisturizer Cream",
        imageName: "cream",
        discount: 20,
        originalPrice: 40.0,
        discountedPrice: 32.0,
        gradientColors: [Color.blue, Color.purple]
    ),
    OfferProduct(
        name: "Lip Balm Pack",
        imageName: "lipbalm",
        discount: 15,
        originalPrice: 15.0,
        discountedPrice: 12.75,
        gradientColors: [Color.green, Color.teal]
    )
]
