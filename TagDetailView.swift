//
//  TagDetailView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 6/11/25.
//

// TagDetailView.swift
import SwiftUI

@available(iOS 17.0, *)
struct TagDetailView: View {
    let tag: String

    var body: some View {
        VStack(spacing: 20) {
            Text("🔖 Tag: \(tag)")
                .font(.largeTitle)
                .bold()

            Text("Here you can show filtered opportunities, analytics, or related matches.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .navigationTitle(tag)
    }
}



#Preview {
    if #available(iOS 17, *) {
        TagDetailView(tag: "Angel")
    } else {
        // Fallback on earlier versions
    }
}

