//
//  CardEntryView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//


import SwiftUI

struct CardEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CardViewModel

    @State private var cardNumber = ""
    @State private var validDate = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var bankName = ""
    @State private var cardType = "Visa"

    @State private var showCardNumberError = false
    @State private var showCVVError = false

    let cardTypes = ["Visa", "Mastercard", "American Express", "RuPay", "Discover"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add New Card")
                    .font(.largeTitle.bold())
                    .padding(.top)

                VStack(spacing: 16) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: cardNumber) { _ in
                            cardNumber = String(cardNumber.prefix(16))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showCardNumberError ? Color.red : Color.clear, lineWidth: 1)
                        )

                    if showCardNumberError {
                        Text("Card number must be 16 digits")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    TextField("Valid Date (MM/YY)", text: $validDate)
                        .keyboardType(.numbersAndPunctuation)
                        .textInputAutocapitalization(.characters)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))

                    SecureField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                        .onChange(of: cvv) { _ in
                            cvv = String(cvv.prefix(4))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showCVVError ? Color.red : Color.clear, lineWidth: 1)
                        )

                    if showCVVError {
                        Text("CVV must be 3 or 4 digits")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    TextField("Cardholder Name", text: $name)
                        .textInputAutocapitalization(.characters)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))

                    TextField("Bank Name", text: $bankName)
                        .textInputAutocapitalization(.words)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))

                    Picker("Card Type", selection: $cardType) {
                        ForEach(cardTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical)

                    Button(action: {
                        scanCard()
                    }) {
                        Label("Scan Card", systemImage: "camera.viewfinder")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: saveCard) {
                        Text("Save Card")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Actions
    private func saveCard() {
        showCardNumberError = cardNumber.count != 16
        showCVVError = !(cvv.count == 3 || cvv.count == 4)

        guard !showCardNumberError && !showCVVError else { return }

        let newCard = Card(
            cardNumber: cardNumber,
            validDate: validDate,
            cvv: cvv,
            name: name.uppercased(),
            bankName: bankName,
            cardType: cardType
        )

        viewModel.saveCard(newCard)
        clearFields()
        dismiss()
    }

    private func clearFields() {
        cardNumber = ""
        validDate = ""
        cvv = ""
        name = ""
        bankName = ""
        cardType = "Visa"
        showCardNumberError = false
        showCVVError = false
    }

    private func scanCard() {
        // Placeholder – you can integrate Card.io or VisionKit here
        print("Scan Card tapped")
    }
}

