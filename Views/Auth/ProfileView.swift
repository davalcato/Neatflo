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
        if #available(iOS 16.0, *) {
            NavigationStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            VStack {
                                if let imageData = profileImageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue)
                                        .shadow(radius: 5)
                                }

                                PhotosPicker("Change Photo", selection: $selectedItem, matching: .images)
                                    .onChange(of: selectedItem) { newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                profileImageData = data
                                            }
                                        }
                                    }
                            }
                            Spacer()
                        }
                    }

                    Section("Personal Info") {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }

                    Section("Account") {
                        NavigationLink("Settings") {}
                        NavigationLink("Notifications") {}
                        NavigationLink("Privacy") {}
                    }

                    Section {
                        Button("Sign Out", role: .destructive) {
                            signOut()
                        }
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
        } else {
            Text("Please update to iOS 16 or later to access Profile features.")
        }
    }

    private func signOut() {
        // Add your sign-out logic here (e.g. FirebaseAuth, clearing user defaults, etc.)
        print("User signed out")
        dismiss()
    }
}


#Preview {
    if #available(iOS 16.0, *) {
        ProfileView()
    } else {
        // Fallback on earlier versions
    }
}
