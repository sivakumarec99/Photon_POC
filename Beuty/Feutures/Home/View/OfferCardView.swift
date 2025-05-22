//
//  OfferCardView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUI

struct OfferCardView: View {
    let product: OfferProduct
    @State private var animate = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: product.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
                .shadow(radius: 4)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .scaleEffect(animate ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                    
                    Spacer()
                    
                    Text("-\(product.discount)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }

                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 5) {
                    Text(String(format: "$%.2f", product.discountedPrice))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(String(format: "$%.2f", product.originalPrice))
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
        .onAppear {
            animate = true
        }
        .padding(.horizontal)
    }
}
