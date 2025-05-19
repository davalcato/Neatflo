//
//  LoginViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/18/25.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var registerUser: Bool = false
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String?
    @Published var registeredAccounts: [String: String] = [:]
    
    init() {
        loadAccounts()
    }
    
    var registerUserValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !reEnterPassword.isEmpty &&
        password == reEnterPassword
    }
    
    var loginUserValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        return registeredAccounts[email] != nil
    }
    
    func saveAccounts() {
        UserDefaults.standard.set(registeredAccounts, forKey: "registeredAccounts")
    }
    
    func loadAccounts() {
        if let accounts = UserDefaults.standard.dictionary(forKey: "registeredAccounts") as? [String: String] {
            registeredAccounts = accounts
        }
    }
    
    func clearForm() {
        email = ""
        password = ""
        reEnterPassword = ""
    }
}


