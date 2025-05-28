//
//  CardViewModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation
import SwiftKeychainWrapper
import FirebaseAuth

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
        
    private var keyPrefix: String {
        guard let uid = Auth.auth().currentUser?.uid else { return "stored_card_" }
        return "stored_card_\(uid)_"
    }
    init() {
        fetchCards()
    }
    
    // Save a new card or update an existing one
    func saveCard(_ card: Card) {
        let key = keyPrefix + card.id.uuidString
        if let encoded = try? JSONEncoder().encode(card) {
            KeychainWrapper.standard.set(encoded, forKey: key)
            fetchCards() // refresh
        }
    }
    
    // Fetch all cards from the keychain
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
    
    // Delete a card from the keychain
    func deleteCard(_ card: Card) {
        let key = keyPrefix + card.id.uuidString
        KeychainWrapper.standard.removeObject(forKey: key)
        fetchCards() // refresh
    }
    
    // Update a card (this is essentially the same as saveCard)
    func updateCard(_ card: Card) {
        saveCard(card) // Reuse saveCard method for updating
    }
}

