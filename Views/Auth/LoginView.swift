//
//  LoginView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginData: LoginViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode

    @State private var showErrorAlert = false
    @State private var showSuccessMessage = false
    @State private var showFailureMessage = false
    @State private var showPassword: Bool = false

    let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.2, green: 0.5, blue: 0.3).opacity(0.8),
            Color(red: 0.4, green: 0.7, blue: 0.5).opacity(0.8)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    let buttonColor = Color(red: 0.3, green: 0.7, blue: 0.5)
    let cardBackground = Color(.systemBackground)

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                gradient.ignoresSafeArea()

                VStack {
                    Spacer()

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text(loginData.registerUser ? "Create Your Account" : "Welcome Back")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    VStack(spacing: 16) {
                        CustomTextField(
                            icon: "envelope.fill",
                            title: "Email",
                            hint: "example@email.com",
                            value: $loginData.email,
                            isSecure: false,
                            showPassword: .constant(false)
                        )
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)

                        CustomTextField(
                            icon: "lock.fill",
                            title: "Password",
                            hint: "Enter your password",
                            value: $loginData.password,
                            isSecure: true,
                            showPassword: $loginData.showPassword
                        )
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)

                        if loginData.registerUser {
                            CustomTextField(
                                icon: "lock.rotation",
                                title: "Re-enter Password",
                                hint: "Re-enter password",
                                value: $loginData.reEnterPassword,
                                isSecure: true,
                                showPassword: $loginData.showReEnterPassword
                            )
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }

                        Button(action: handleAuthAction) {
                            Text(loginData.registerUser ? "Register" : "Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        if showSuccessMessage {
                            Text("✅ Registration successful!")
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }

                        if showFailureMessage {
                            Text("❌ Registration failed. Try again.")
                                .foregroundColor(.red)
                                .transition(.opacity)
                        }

                        Text("or continue with")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 8)

                        Button(action: {
                            print("Mock Google Sign-In")
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                Text("Sign in with Google")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(10)
                        }

                        Button(action: {
                            print("Mock Facebook Sign-In")
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "f.circle.fill")
                                Text("Sign in with Facebook")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(10)
                        }

                        Button(action: {
                            withAnimation {
                                loginData.registerUser.toggle()
                            }
                        }) {
                            Text(loginData.registerUser ? "Already have an account? Login" : "Don't have an account? Register")
                                .font(.footnote)
                                .foregroundColor(.green)
                                .padding(8)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(cardBackground)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.horizontal, 24)

                    Spacer()
                }

                // Back Button (Icon Only - Blue)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .padding()
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(loginData.errorMessage ?? "Something went wrong."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Login/Register Logic
    private func handleAuthAction() {
        if loginData.registerUser {
            if loginData.registerUserValid {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showSuccessMessage = true
                    showFailureMessage = false
                    appState.isLoggedIn = true
                }
            } else {
                loginData.errorMessage = "Please make sure all fields are filled and passwords match."
                showErrorAlert = true
            }
        } else {
            if loginData.loginUserValid {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    appState.isLoggedIn = true
                }
            } else {
                loginData.errorMessage = "Email and password cannot be empty."
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    LoginView(loginData: LoginViewModel())
        .environmentObject(AppState())
}





