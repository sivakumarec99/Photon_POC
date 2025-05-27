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
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.products) { product in
                            productGridTile(for: product)
                        }.onDelete(perform: delete)
                    }
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
    private func productGridTile(for product: Product) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                ProductImageView(imageUrl: product.image, width: 150, height: 150)
                    .environmentObject(viewModel)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Button {
                    viewModel.toggleFavorite(for: product)
                } label: {
//                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
//                        .padding(8)
//                        .foregroundColor(product.isFavorite ? .red : .gray)
//                        .background(.ultraThinMaterial)
//                        .clipShape(Circle())
//                        .shadow(radius: 2)
                }
                .padding(6)
            }

            Text(product.title)
                .font(.headline)
                .lineLimit(2)

            Text("$\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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

struct ProductImageView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Group {
            if let url = URL(string: imageUrl),
               let image = viewModel.imageCache[url] {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                PlaceholderShape(color: .gray, height: height, width: width)
                    .shimmer(isActive: true, gradientColors: [.gray, .white])
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task {
            await viewModel.loadImage(for: imageUrl)
        }
    }
}

