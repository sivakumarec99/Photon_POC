//
//  CardViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation
import SwiftKeychainWrapper

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
    
    private let keyPrefix = "stored_card_"
    
    init() {
        fetchCards()
    }
    
    func saveCard(_ card: Card) {
        let key = keyPrefix + card.id.uuidString
        if let encoded = try? JSONEncoder().encode(card) {
            KeychainWrapper.standard.set(encoded, forKey: key)
            fetchCards() // refresh
        }
    }
    
    func fetchCards() {
        var loadedCards: [Card] = []
        for key in KeychainWrapper.standard.allKeys() where key.hasPrefix(keyPrefix) {
            if let data = KeychainWrapper.standard.data(forKey: key),
               let card = try? JSONDecoder().decode(Card.self, from: data) {
                loadedCards.append(card)
            }
        }
        self.cards = loadedCards
    }
}
