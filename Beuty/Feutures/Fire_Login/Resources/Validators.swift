//
//  Validators.swift
//  Login
//
//  Created by Sivakumar Rajendiran on 27/05/25.
//

import Foundation


struct Validators {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
