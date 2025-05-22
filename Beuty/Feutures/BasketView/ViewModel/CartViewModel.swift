//
//  CartViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [Product] = []
    
    var subtotal: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
    
    var gst: Double {
        subtotal * 0.18 // 18% GST
    }
    
    var total: Double {
        subtotal + gst
    }
    
    var deliveryDate: String {
        let date = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func addToCart(_ product: Product) {
        cartItems.append(product)
    }
    
//    func removeFromCart(_ product: Product) {
//        cartItems.removeAll { $0 == product }
//    }
}
