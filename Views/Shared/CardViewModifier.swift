//
//  CardViewModifier.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/23/25.
//

import SwiftUI

extension View {
    func cardView() -> some View {
        self
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    Text("Preview of Card View")
        .cardView()
        .padding()
        .previewLayout(.sizeThatFits)
}
