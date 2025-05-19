//
//  AppState.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import Foundation

@available(iOS 13.0, *)
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
