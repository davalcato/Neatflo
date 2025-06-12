//
//  BlurView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/30/25.
//

import SwiftUI


struct CustomBlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    BlurView(style: .systemMaterial)
        .frame(width: 300, height: 200)
}
