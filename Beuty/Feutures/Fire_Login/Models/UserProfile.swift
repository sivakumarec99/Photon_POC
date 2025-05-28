//
//  UserProfile.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//


import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var fullName: String
    var phone: String?
    var createdAt: Date
}
