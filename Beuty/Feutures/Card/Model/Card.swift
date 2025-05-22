//
//  Card.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import Foundation

struct Card: Codable, Identifiable {
    var id: UUID = UUID()
    var cardNumber: String
    var validDate: String
    var cvv: String
    var name: String
    var bankName: String
}
