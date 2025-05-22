//
//  ShopView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUI

struct ShopView: View {
    @StateObject private var viewModel = ProductViewModel(
        domainURL: URL(string: "https://fakestoreapi.com")!
    )

    let shimmerGradient = [
        Color.gray.opacity(0.4),  // Base color for shimmer placeholder
        Color.gray.opacity(0.2),  // Highlight color for shimmer
        Color.gray.opacity(0.4),  // Base color for shimmer placeholder
    ]
    let placeholderBackgroundColor = Color(uiColor: .systemGray5)

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading && viewModel.products.isEmpty {
                    // --- Shimmering Placeholders ---
                    ForEach(0..<5) { _ in  // Show a few placeholders
                        productPlaceholderCard
                    }
                } else {
                    // --- Actual Product Data ---
                    ForEach(viewModel.products) { product in
                        productCard(for: product)
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await viewModel.fetchProducts()
                        }
                    }
                }
            }
            .onAppear {
                if viewModel.products.isEmpty {  // Fetch only if products are not already loaded
                    Task {
                        await viewModel.fetchProducts()
                    }
                }
            }
            .alert(item: $viewModel.errorMessage) { message in
                Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let product = viewModel.products[index]
                await viewModel.deleteProduct(id: product.id)
            }
        }
    }
    
    @ViewBuilder
    private func productCard(for product: Product) -> some View {
        HStack(alignment: .top, spacing: 15) {
            // --- Updated AsyncImage for Product Image ---
            // This assumes 'product.imageUrl' is a non-optional String.
            // URL(string:) still returns an optional URL (URL?),
            // as the string might not be a valid URL format.
            AsyncImage(url: URL(string: product.image)) { phase in // Changed here
                switch phase {
                case .empty:  // Placeholder while loading or if URL is invalid
                    PlaceholderShape(
                        color: placeholderBackgroundColor, // Make sure this is defined in your View's scope
                        height: 80, width: 80 // Corrected parameter order if PlaceholderShape expects width then height
                    )
                    .shimmer(isActive: true, gradientColors: shimmerGradient) // Make sure shimmerGradient is defined
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:  // Placeholder on error (e.g., network issue, or if URL was valid but image couldn't be fetched)
                    ZStack {
                        PlaceholderShape(
                            color: placeholderBackgroundColor,
                            height: 80, width: 80
                        )
                        Image(systemName: "photo.fill")
                            .foregroundColor(.gray)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80) // Ensure the frame is on AsyncImage itself or its container

            VStack(alignment: .leading, spacing: 5) {
                Text(product.title)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var productPlaceholderCard: some View {
           HStack(alignment: .top, spacing: 15) {
               PlaceholderShape(color: placeholderBackgroundColor, height: 80, width: 80)

               VStack(alignment: .leading, spacing: 8) { // Matched spacing with content
                   PlaceholderShape(color: placeholderBackgroundColor, height: 20) // Title
                   PlaceholderShape(color: placeholderBackgroundColor, height: 15, width: 100) // Price
                   PlaceholderShape(color: placeholderBackgroundColor, height: 12) // Description line 1
                   PlaceholderShape(color: placeholderBackgroundColor, height: 12) // Description line 2
                   PlaceholderShape(color: placeholderBackgroundColor, height: 12, width: 150) // Description line 3
               }
           }
           .padding(.vertical, 8)
           .shimmer(isActive: true, gradientColors: shimmerGradient)
       }
}


extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    var gradientColors: [Color]
    var animationSpeed: Double

    func body(content: Content) -> some View {
        content
            .modifier(AnimatedMask(phase: phase, gradientColors: gradientColors))
            .animation(
                Animation.linear(duration: animationSpeed)
                    .repeatForever(autoreverses: false),
                value: phase
            )
            .onAppear {
                phase = 0.8 // End point of the gradient animation
            }
    }

    struct AnimatedMask: AnimatableModifier {
        var phase: CGFloat = 0
        var gradientColors: [Color]

        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        func body(content: Content) -> some View {
            content
                .mask(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .init(x: phase - 0.5, y: 0.5),
                        endPoint: .init(x: phase + 0.5, y: 0.5)
                    )
                )
        }
    }
}


extension View {
    @ViewBuilder // Add this attribute
    func shimmer(
        isActive: Bool = true,
        gradientColors: [Color] = [
            Color.black.opacity(0.3),  // Darker part of shimmer
            Color.black.opacity(0.1),  // Lighter part (highlight)
            Color.black.opacity(0.3)   // Darker part of shimmer
        ],
        speed: Double = 1.5  // Duration of one shimmer cycle
    ) -> some View {
        if isActive {
            self.modifier(
                ShimmerEffect(
                    gradientColors: gradientColors,
                    animationSpeed: speed
                )
            )
        } else {
            self // No changes needed here
        }
    }
}

// Helper for placeholder shapes
struct PlaceholderShape: View {
    var color: Color = Color(uiColor: .systemGray5)  // Base placeholder color
    var height: CGFloat? = nil
    var width: CGFloat? = nil
    var cornerRadius: CGFloat = 6

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
    }
}
