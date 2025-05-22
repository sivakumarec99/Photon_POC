//
//  CardEntryView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import SwiftUI

struct CardEntryView: View {
    @StateObject var viewModel: CardViewModel
    @State private var cardNumber = ""
    @State private var validDate = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var bankName = ""
    
    var body: some View {
        Form {
            Section(header: Text("Enter Card Details")) {
                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.numberPad)
                TextField("Valid Date (MM/YY)", text: $validDate)
                SecureField("CVV", text: $cvv)
                    .keyboardType(.numberPad)
                TextField("Cardholder Name", text: $name)
                TextField("Bank Name", text: $bankName)
            }
            
            Button("Save Card") {
                let newCard = Card(
                    cardNumber: cardNumber,
                    validDate: validDate,
                    cvv: cvv,
                    name: name,
                    bankName: bankName
                )
                viewModel.saveCard(newCard)
                clearFields()
            }
        }
        .navigationTitle("Add New Card")
    }
    
    private func clearFields() {
        cardNumber = ""
        validDate = ""
        cvv = ""
        name = ""
        bankName = ""
    }
}
