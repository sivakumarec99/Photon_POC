//
//  CartView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import SwiftUI

struct BasketView: View {
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        VStack {
            if viewModel.cartItems.isEmpty {
                Text("🛒 Your cart is empty").foregroundColor(.gray)
            } else {
//                List {
//                    ForEach(viewModel.cartItems) { item in
//                        HStack {
//                            Text(item.image)
//                            VStack(alignment: .leading) {
//                                Text(item.name)
//                                Text("₹\(String(format: "%.2f", item.price))")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                            Spacer()
//                            Button("❌") {
//                                viewModel.removeFromCart(item)
//                            }
//                            .foregroundColor(.red)
//                        }
//                    }
//                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Subtotal: ₹\(String(format: "%.2f", viewModel.subtotal))")
                    Text("GST (18%): ₹\(String(format: "%.2f", viewModel.gst))")
                    Text("Total: ₹\(String(format: "%.2f", viewModel.total))")
                        .font(.headline)
                    Text("Estimated Delivery: \(viewModel.deliveryDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .navigationTitle("Cart Summary")
    }
}
