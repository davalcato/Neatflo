//
//  ProfileView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 6/9/25.
//

// ProfileView.swift
import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("profileImage") private var profileImageData: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showSignOutSheet = false

    var fullName: String {
        let f = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let l = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(f) \(l)".trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated Gradient Background
                LinearGradient(colors: [.blue, .purple, .indigo],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 25) {
                    Spacer(minLength: 40)

                    // Profile Image Section
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 160, height: 160)
                            .shadow(color: .black.opacity(0.2), radius: 10)

                        if let data = profileImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }

                    PhotosPicker("Edit Photo", selection: $selectedItem, matching: .images)
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(.top, -12)
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    profileImageData = data
                                }
                            }
                        }

                    // Full Name
                    if !fullName.isEmpty {
                        Text(fullName)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .transition(.opacity)
                    }

                    // Info Card
                    VStack(spacing: 16) {
                        Group {
                            HStack {
                                Text("First Name")
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                            }
                            TextField("First Name", text: $firstName)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.white)

                            HStack {
                                Text("Last Name")
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                            }
                            TextField("Last Name", text: $lastName)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundColor(.white)
                        }

                        Divider().background(Color.white.opacity(0.4))

                        VStack(spacing: 12) {
                            NavigationLink(destination: Text("Notification Settings")) {
                                Label("Notifications", systemImage: "bell.badge")
                            }
                            NavigationLink(destination: Text("Privacy Settings")) {
                                Label("Privacy", systemImage: "lock.shield")
                            }
                        }
                        .font(.body)
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 10)
                    .padding(.horizontal)

                    Spacer()

                    // Sign Out Button
                    Button {
                        showSignOutSheet.toggle()
                    } label: {
                        Text("Sign Out")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .navigationTitle("")
                .navigationBarHidden(true)
                .sheet(isPresented: $showSignOutSheet) {
                    SignOutConfirmation {
                        signOut()
                    }
                }
            }
        }
    }

    private func signOut() {
        firstName = ""
        lastName = ""
        profileImageData = nil
        dismiss()
    }
}

// SignOutConfirmation Bottom Sheet
@available(iOS 16.0, *)
struct SignOutConfirmation: View {
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.top, 10)

            Text("Are you sure you want to sign out?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top)

            Button("Sign Out", role: .destructive) {
                onConfirm()
                dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundColor(.white)

            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}


