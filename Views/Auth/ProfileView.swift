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
    @State private var animateImage = false
    @State private var showSignOutConfirmation = false

    var fullName: String {
        let f = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let l = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(f) \(l)".trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        ZStack {
                            LinearGradient(colors: [Color.purple, Color.blue],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .shadow(radius: 10)

                            VStack(spacing: 12) {
                                // Profile Image
                                Group {
                                    if let imageData = profileImageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .scaleEffect(animateImage ? 1 : 0.8)
                                            .animation(.easeOut(duration: 0.4), value: animateImage)
                                    } else {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(.white.opacity(0.8))
                                            .scaleEffect(animateImage ? 1 : 0.8)
                                            .animation(.easeOut(duration: 0.4), value: animateImage)
                                    }
                                }

                                // Name
                                if !fullName.isEmpty {
                                    Text(fullName)
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                }

                                PhotosPicker("Change Photo", selection: $selectedItem, matching: .images)
                                    .foregroundColor(.white)
                                    .font(.caption)
                                    .padding(.top, 4)
                                    .onChange(of: selectedItem) { newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                profileImageData = data
                                            }
                                        }
                                    }
                            }
                            .padding(.top, 40)
                        }

                        // Form
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Personal Info")
                                .font(.title3.bold())

                            TextField("First Name", text: $firstName)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 3)

                            TextField("Last Name", text: $lastName)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 3)

                            Divider()

                            Text("Settings")
                                .font(.title3.bold())

                            VStack(spacing: 12) {
                                NavigationLink("Notifications") {}
                                NavigationLink("Privacy") {}
                                NavigationLink("Terms of Use") {}
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)

                        Spacer(minLength: 50)
                    }
                }

                // Sign Out Floating Button
                VStack {
                    Spacer()
                    Button {
                        showSignOutConfirmation = true
                    } label: {
                        Text("Sign Out")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(colors: [Color.red, Color.orange], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 6)
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                animateImage = true
            }
            .alert("Are you sure you want to sign out?", isPresented: $showSignOutConfirmation) {
                Button("Sign Out", role: .destructive) { signOut() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private func signOut() {
        firstName = ""
        lastName = ""
        profileImageData = nil
        print("User signed out")
        dismiss()
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        ProfileView()
    } else {
        Text("Update to iOS 16+")
    }
}

