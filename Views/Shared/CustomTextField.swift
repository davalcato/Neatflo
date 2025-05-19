//
//  CustomTextField.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/18/25.
//

import SwiftUI

struct CustomTextField: View {
    var icon: String
    var title: String
    var hint: String
    @Binding var value: String
    var isSecure: Bool
    @Binding var showPassword: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                if isSecure && !showPassword {
                    SecureField(hint, text: $value)
                } else {
                    TextField(hint, text: $value)
                }

                if isSecure {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.top)
    }
}


#Preview {
    struct CustomTextFieldPreviewWrapper: View {
        @State private var email = "test@example.com"
        @State private var showPassword = false

        var body: some View {
            CustomTextField(
                icon: "envelope",
                title: "Email",
                hint: "example@example.com",
                value: $email,
                isSecure: false,
                showPassword: .constant(false) // not used when `isSecure` is false
            )
            .padding()
        }
    }

    return CustomTextFieldPreviewWrapper()
}

