//
//  ProductViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // ✅ Image Cache
    @Published var imageCache: [URL: UIImage] = [:]

    private let apiService: APIService

    init(domainURL: URL) {
        self.apiService = APIService(domainURL: domainURL)
        isLoading = true
    }

    // MARK: - Load Products
    func fetchProducts() async {
        do {
            let fetchedProducts: [Product] = try await apiService.get(endpoint: "/products")
            products = fetchedProducts
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
        }
    }

    // MARK: - Download Product Image (async)
    func loadImage(for urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        // Skip if already cached
        if imageCache[url] != nil { return }

        do {
            let imageV = try await apiService.downloadImage(from: urlString)
            if let image = imageV {
                imageCache[url] = image
            }
        } catch {
            print("❌ Image download failed: \(error.localizedDescription)")
        }
    }

    // MARK: - CRUD APIs
    func addProduct(_ product: Product) async {
        do {
            let newProduct: Product = try await apiService.post(endpoint: "/products", body: product)
            products.append(newProduct)
            isLoading = false
        } catch {
            errorMessage = "Failed to add product: \(error.localizedDescription)"
        }
    }

    func updateProduct(_ product: Product) async {
        do {
            let updatedProduct: Product = try await apiService.update(endpoint: "/products/\(product.id)", body: product)
            if let index = products.firstIndex(where: { $0.id == updatedProduct.id }) {
                products[index] = updatedProduct
                isLoading = false
            }
        } catch {
            errorMessage = "Failed to update product: \(error.localizedDescription)"
        }
    }

    func deleteProduct(id: Int) async {
        do {
            try await apiService.delete(endpoint: "/products/\(id)")
            products.removeAll { $0.id == id }
            isLoading = false
        } catch {
            errorMessage = "Failed to delete product: \(error.localizedDescription)"
        }
    }
    
    // toggle
    func toggleFavorite(for product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        //products[index].isFavorite.toggle()
    }
}
