//
//  AuthService.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    @Published var isLoggedIn = false
    
    func login(email: String, password: String) async throws {
        // Firebase auth logic
        isLoggedIn = true
    }
}
