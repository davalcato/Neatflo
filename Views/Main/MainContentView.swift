//
//  MainContentView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/19/25.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            // Tab 1 - Home/Dashboard
            NavigationView {
                VStack {
                    Text("Welcome to Neatflo!")
                        .font(.title)
                    
                    Button(action: {
                        appState.isLoggedIn = false
                    }) {
                        Text("Log Out")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                }
                .navigationTitle("Dashboard")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            // Tab 2 - Other Features
            NavigationView {
                Text("Other Features View")
                    .navigationTitle("Features")
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Features")
            }
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
            .environmentObject(AppState())
    }
}
