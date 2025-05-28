//
//  DemoPageView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 23/05/25.
//


import SwiftUI

struct DemoPageView: View {
    let pageNumber: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "figure.\(pageNumber).circle.fill") // Example icon
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue.opacity(0.7))

            Text("Demo Screen \(pageNumber)")
                .font(.title)
                .fontWeight(.bold)

            Text("This is some informative text for demo screen number \(pageNumber). Explain a key feature or benefit here.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Spacer()
            Spacer() // Add more space to push content up if needed
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Ensure white background if not covered
    }
}

struct DemoPageView_Previews: PreviewProvider {
    static var previews: some View {
        DemoPageView(pageNumber: 1)
    }
}