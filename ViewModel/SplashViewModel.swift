//
//  SplashViewModel.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import Foundation

final class SplashViewModel: ObservableObject {
    @Published var isActive = false
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
    }
    
    func checkAuthStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Check auth status (replace with your logic)
            self.isActive = true
        }
    }
}
