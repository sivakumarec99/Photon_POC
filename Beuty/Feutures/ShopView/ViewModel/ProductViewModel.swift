//
//  ProductViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import Alamofire

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let apiService: APIService
    
    init(domainURL: URL) {
        self.apiService = APIService(domainURL: domainURL)
        isLoading =  true
    }
   
    
    // Load all products (GET)
    func fetchProducts() async {
        do {
            let fetchedProducts: [Product] = try await apiService.get(endpoint: "/products")
            products = fetchedProducts
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch products: \(error.localizedDescription)"
        }
    }
    
    // Add a new product (POST)
    func addProduct(_ product: Product) async {
        do {
            let newProduct: Product = try await apiService.post(endpoint: "/products", body: product)
            products.append(newProduct)
            isLoading = false
        } catch {
            errorMessage = "Failed to add product: \(error.localizedDescription)"
        }
    }
    
    // Update product (PUT)
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
    
    // Delete product (DELETE)
    func deleteProduct(id: Int) async {
        do {
            try await apiService.delete(endpoint: "/products/\(id)")
            products.removeAll { $0.id == id }
            isLoading = false
        } catch {
            errorMessage = "Failed to delete product: \(error.localizedDescription)"
        }
    }
}



