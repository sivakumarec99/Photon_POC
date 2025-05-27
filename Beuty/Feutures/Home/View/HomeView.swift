//
//  HomeView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var selectedTopTab = 0
    @State private var navigateToMoreView = false
    var body: some View {
        VStack(spacing: 0) {
            topBar
            locationBar
            topTabView
            HomeBody
            Spacer()
            bottomTabBar
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var HomeBody: some View {
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    AdvantageCardView(
                        onSignUp: {
                            print("Sign Up Tapped")
                            selectedTopTab = 4
                        },
                        onLinkCard: {
                            print("Link Card Tapped")
                            // Navigate or present link card flow
                        }
                    )
                    .padding(.top)
                    VStack(spacing: 16) {
                        ForEach(mockOffers) { product in
                            OfferCardView(product: product)
                        }
                    }
                    .padding(.top)
                }
            }
            .onAppear(){
                
            }
                
    }
    
    // MARK: - Top Profile and Notification
    var topBar: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            Text("WelcomeBoots")
                .font(.headline)
                .padding(.leading, 5)
            
            Spacer()
             
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 24))
                .foregroundColor(.orange)
        }
        .padding()
    }

    // MARK: - Location Bar
    var locationBar: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.green)
            Text("Showing my location: 123 Main Street, City")
                .font(.subheadline) 
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    // MARK: - Top Tabs (Shop / Healthcare)
    var topTabView: some View {
        HStack {
            Button(action: { selectedTopTab = 0 }) {
                Text("Shop")
                    .fontWeight(selectedTopTab == 0 ? .bold : .regular)
                    .foregroundColor(selectedTopTab == 0 ? .blue : .gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
            
            Button(action: { selectedTopTab = 1 }) {
                Text("Healthcare")
                    .fontWeight(selectedTopTab == 1 ? .bold : .regular)
                    .foregroundColor(selectedTopTab == 1 ? .blue : .gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    // MARK: - Bottom TabBar
    var bottomTabBar: some View {
        HStack {
            bottomTabItem(title: "Home", icon: "house.fill", selected: true)
            bottomTabItem(title: "Shop", icon: "bag.fill")
            bottomTabItem(title: "MyCard", icon: "creditcard.fill")
            bottomTabItem(title: "Basket", icon: "cart.fill")
            bottomTabItem(title: "More", icon: "ellipsis.circle.fill")
        }
        .padding(.top)
        .padding(.bottom, 10)
        .background(Color.white.shadow(radius: 3))
    }
    
    func bottomTabItem(title: String, icon: String, selected: Bool = false) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(selected ? .blue : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(selected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}


struct AdvantageCardView: View {
    var onSignUp: () -> Void
    var onLinkCard: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Boots Advantage Card")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // Description
            Text("Get more out of your Boots shop for less. Sign up or link your Advantage Card today.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Benefits List
            VStack(alignment: .leading, spacing: 8) {
                benefitItem("🟢 Price advantage discounts")
                benefitItem("🟢 Collect 3 points for every $1")
                benefitItem("🟢 Personalized offers")
            }

            // Action Buttons
            HStack {
                Button(action: onSignUp) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button(action: onLinkCard) {
                    Text("Link Card")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    private func benefitItem(_ text: String) -> some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.body)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}


