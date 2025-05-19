//
//  LoginViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/18/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var registerUser: Bool = false
    @Published var registerUserValid: Bool = false
    @Published var loginUserValid: Bool = false
    @Published var showPassword: Bool = false
    @Published var reEnterPassword: String = ""
    @Published var showReEnterPassword: Bool = false
    

    func login() {
        errorMessage = nil

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        isLoading = true

        // Simulate async login logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false

            if self.email.lowercased() == "test@neatflo.com" && self.password == "password" {
                print("✅ Logged in successfully!")
                // Navigate to FeedView, Dashboard, etc.
            } else {
                self.errorMessage = "Invalid email or password."
            }
        }
    }
}


