//
//  MainContentView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var loginData: LoginViewModel

    var body: some View {
        Group {
            if appState.isLoggedIn {
                if #available(iOS 17.0, *) {
                    FeedView()
                } else {
                    // Fallback for earlier versions
                    Text("Upgrade to iOS 17+ for full features.")
                }
            } else {
                LoginView(loginData: loginData)
            }
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
            .environmentObject(AppState())
            .environmentObject(LoginViewModel())
    }
}


