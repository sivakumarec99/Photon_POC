//
//  SearchBarView.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//


import SwiftUI
import GooglePlaces

struct SearchBarView: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search for a place...", text: $viewModel.searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchPlaces()
                }

            if !viewModel.predictions.isEmpty {
                List(viewModel.predictions, id: \.placeID) { prediction in
                    Button(action: {
                        viewModel.selectPlace(prediction)
                        viewModel.searchText = prediction.attributedPrimaryText.string
                        viewModel.predictions = [] // clear results
                    }) {
                        VStack(alignment: .leading) {
                            Text(prediction.attributedPrimaryText.string)
                                .fontWeight(.bold)
                            Text(prediction.attributedSecondaryText?.string ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
    }
}