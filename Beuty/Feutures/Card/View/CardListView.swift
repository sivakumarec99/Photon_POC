//
//  CardListView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import SwiftUI

struct CardListView: View {
   //
    @StateObject private var viewModel = CardViewModel()
    
    //
    @State private var showCardEntry = false
    @State private var showDeleteAlert = false
    @State private var cardToDelete: Card?
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cards.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "creditcard.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue.opacity(0.6))
                        
                        Text("No Cards Saved")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            showCardEntry = true
                        }) {
                            Label("Add Your First Card", systemImage: "plus")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 80)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.cards) { card in
                            CreditCardView(card: card)
                                .padding(.vertical, 8)
                                .onLongPressGesture {
                                    cardToDelete = card
                                    showDeleteAlert = true
                                }
                        }
                        .onDelete(perform: deleteCard)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCardEntry = true
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showCardEntry) {
                CardEntryView(viewModel: viewModel)
            }
           
        }
    }
    private func deleteCard(at offsets: IndexSet) {
        for index in offsets {
            let card = viewModel.cards[index]
            viewModel.deleteCard(card)
        }
    }
}

struct CreditCardView: View {
    let card: Card
    @State private var animate = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(card.bankName.uppercased())
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .bold()
                    Spacer()
                    Image(systemName: "creditcard")
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text(formatCardNumber(card.cardNumber))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .tracking(4)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("CARD HOLDER")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.name)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("EXPIRES")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.validDate)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(height: 220)
        .scaleEffect(animate ? 1.0 : 0.95)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.5), value: animate)
        .onAppear {
            animate = true
        }
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        return stride(from: 0, to: cleaned.count, by: 4).map {
            let start = cleaned.index(cleaned.startIndex, offsetBy: $0)
            let end = cleaned.index(start, offsetBy: 4, limitedBy: cleaned.endIndex) ?? cleaned.endIndex
            return String(cleaned[start..<end])
        }.joined(separator: " ")
    }
}

