//
//  FirebaseService.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    func registerUser(email: String, password: String, fullName: String, phone: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let user = result?.user else { return }

            let profile = UserProfile(
                id: user.uid,
                email: email,
                fullName: fullName,
                phone: phone,
                createdAt: Date()
            )
            do {
                try self.db.collection("users").document(user.uid).setData(from: profile)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                return completion(.failure(error))
            }
            completion(.success(()))
        }
    }

    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            }
            do {
                if let user = try snapshot?.data(as: UserProfile.self) {
                    completion(.success(user))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = profile.id else { return }
        do {
            try db.collection("users").document(uid).setData(from: profile)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
