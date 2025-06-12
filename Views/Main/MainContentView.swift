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
                    NavigationStack {
                        FeedView()
                            .environmentObject(appState)
                            .environmentObject(loginData)
                    }
                } else {
                    Text("Upgrade to iOS 17+ for full features.")
                        .padding()
                        .multilineTextAlignment(.center)
                }
            } else {
                LoginView(loginData: loginData)
                    .environmentObject(appState)
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



