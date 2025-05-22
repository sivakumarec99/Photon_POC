//
//  TabItemModel.swift
//  Beuty
//
//  Created by Sivakumar Rajendiran on 22/05/25.
//

import Foundation
import SwiftUI

struct TabItemModel: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let view: AnyView
}
