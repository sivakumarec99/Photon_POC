//
//  MapScreen.swift
//  Beuty
//
//  Created by Sivakumar R on 29/05/25.
//
import SwiftUI

struct MapScreen: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(viewModel: viewModel)

            if !viewModel.selectedAddress.isEmpty {
                Text("Selected: \(viewModel.selectedAddress)")
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let coordinate = viewModel.selectedLocation {
                MapViewRepresentable(coordinate: coordinate)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Spacer()
                Text("No location selected")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .onAppear {
            // Optional: set default location if needed
        }
    }
}
