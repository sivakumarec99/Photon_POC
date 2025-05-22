//
//  MainTabView.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex: Int = 0

    private let tabItems: [TabItemModel] = [
        TabItemModel(title: "Home", icon: "house.fill", view: AnyView(HomeView())),
        TabItemModel(title: "Shop", icon: "bag.fill", view: AnyView(ShopView())),
        TabItemModel(title: "MyCard", icon: "creditcard.fill", view: AnyView(MyCardView())),
        TabItemModel(title: "Basket", icon: "cart.fill", view: AnyView(BasketView(viewModel: CartViewModel()))),
        TabItemModel(title: "More", icon: "ellipsis.circle.fill", view: AnyView(MoreView()))
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            tabItems[selectedIndex].view
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom)
            
            bottomTabBar
                .background(Color.white)
        }
    }

    private var bottomTabBar: some View {
        HStack {
            ForEach(tabItems.indices, id: \.self) { index in
                let item = tabItems[index]
                TabBarItemView(
                    title: item.title,
                    icon: item.icon,
                    isSelected: selectedIndex == index
                ) {
                    selectedIndex = index
                }
            }
        }
        .padding(.vertical, 10)
        .background(Color.white.shadow(radius: 3))
    }
}
