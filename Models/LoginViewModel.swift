//
//  LoginViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/18/25.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var registerUser: Bool = false
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String?
    @Published var registeredAccounts: [String: String] = [:]
    
    // MARK: - Error Types
    enum LoginError: String {
        case emptyFields = "Please fill all fields"
        case invalidEmail = "Please enter a valid email address"
        case weakPassword = "Password must be at least 8 characters"
        case passwordMismatch = "Passwords don't match"
        case emailExists = "Email already registered"
        case incorrectCredentials = "Invalid email or password"
    }
    
    // MARK: - Initialization
    init() {
        loadAccounts()
    }
    
    // MARK: - Validation Methods
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        password.count >= 8
    }
    
    // MARK: - Account Management
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
    
    // MARK: - Computed Properties
    var registerUserValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !reEnterPassword.isEmpty &&
        password == reEnterPassword &&
        validateEmail(email) &&
        validatePassword(password)
    }
    
    var loginUserValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        registeredAccounts[email] != nil
    }
} 


