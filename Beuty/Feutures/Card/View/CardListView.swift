//
//  CardListView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import SwiftUI

struct MyCardView: View {
    var body: some View {
        CardListView()
    }
}

struct CardListView: View {
    @StateObject private var viewModel = CardViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cards.isEmpty {
                    Text("No Cards Saved").foregroundColor(.gray)
                } else {
                    List(viewModel.cards) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("💳 \(card.cardNumber)")
                                .font(.headline)
                            Text("Expires: \(card.validDate)")
                            Text("Cardholder: \(card.name)")
                            Text("Bank: \(card.bankName)")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                
                NavigationLink(destination: CardEntryView(viewModel: viewModel)) {
                    Text("➕ Add New Card")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("My Cards")
        }
    }
}
