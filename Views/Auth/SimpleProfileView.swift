//
//  SimpleProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/30/25.
//

import SwiftUI

struct SimpleProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("User Profile")
                .font(.title)
        }
    }
}

#Preview {
    SimpleProfileView()
}
