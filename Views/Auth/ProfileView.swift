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

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3), Color.pink.opacity(0.3)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Profile image with glow ring
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        lineWidth: 4
                                    )
                                    .frame(width: 120, height: 120)

                                if let imageData = profileImageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .shadow(radius: 8)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue.opacity(0.6))
                                        .shadow(radius: 8)
                                }
                            }

                            PhotosPicker("Change Photo", selection: $selectedItem, matching: .images)
                                .font(.caption)
                                .padding(8)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            profileImageData = data
                                        }
                                    }
                                }
                        }

                        // Info Card
                        VStack(spacing: 16) {
                            Group {
                                TextField("First Name", text: $firstName)
                                TextField("Last Name", text: $lastName)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))

                            NavigationLink("Settings") {}
                                .profileLinkStyle()

                            NavigationLink("Notifications") {}
                                .profileLinkStyle()

                            NavigationLink("Privacy") {}
                                .profileLinkStyle()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)

                        // Sign Out
                        Button(action: signOut) {
                            Text("Sign Out")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Your Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func signOut() {
        // Add your sign-out logic here (e.g. FirebaseAuth, clearing user defaults, etc.)
        print("User signed out")
        dismiss()
    }
}

// MARK: - View Modifier for Buttons
@available(iOS 16.0, *)
extension View {
    func profileLinkStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.6))
            .cornerRadius(12)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        ProfileView()
    } else {
        Text("Update to iOS 16+")
    }
}

