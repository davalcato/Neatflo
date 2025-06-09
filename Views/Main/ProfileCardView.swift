//
//  ProfileCardView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 5/20/25.
//

import SwiftUI

@available(iOS 17, *)
struct ProfileCardView: View {
    let profiles: [Profile]
    
    @State private var showSearch = false
    @State private var searchText = ""

    var filteredProfiles: [Profile] {
        if searchText.isEmpty {
            return profiles
        } else {
            return profiles.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.company.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar Header Area
                ZStack {
                    LinearGradient(colors: [Color.indigo.opacity(0.4), Color.pink.opacity(0.4)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .frame(height: 100)
                        .shadow(radius: 5)

                    HStack {
                        Spacer()

                        if showSearch {
                            TextField("Search Investors", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .animation(.easeInOut, value: showSearch)
                        }

                        Button(action: {
                            withAnimation {
                                showSearch.toggle()
                                if !showSearch {
                                    searchText = ""
                                }
                            }
                        }) {
                            Image(systemName: showSearch ? "xmark.circle.fill" : "magnifyingglass")
                                .imageScale(.large)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.top, 48)
                    .padding(.horizontal)
                }

                ScrollView {
                    VStack(spacing: 20) {
                        Text("💼 AI-Matched Investors")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .yellow],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                            .padding(.top)

                        ForEach(filteredProfiles, id: \.id) { profile in
                            ProfileCard(profile: profile)
                        }
                    }
                }
                .background(
                    LinearGradient(colors: [Color.purple.opacity(0.25),
                                            Color.blue.opacity(0.2),
                                            Color.pink.opacity(0.25)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                )
            }
        }
    }
}

@available(iOS 17, *)
struct ProfileCard: View {
    let profile: Profile

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                NavigationLink(destination: InvestorDetailView(profile: profile)) {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.title3.bold())
                    Text(profile.title + " @ " + profile.company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            Text(profile.bio)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)

            HStack {
                Label("Raised: \(profile.raised)", systemImage: "chart.bar.fill")
                    .font(.footnote)
                    .foregroundColor(.blue)
                Spacer()
                Label(profile.role, systemImage: "person.crop.circle.fill")
                    .font(.footnote)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [.white, .blue.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }

    var profileImage: Image {
        if profile.name == "Sarah Kim" {
            return Image("sarah_kim")
        } else if profile.name == "Nina Rao" {
            return Image("Nina_Rao")
        } else if profile.name == "Tom Lee" {
            return Image("Tom_Lee")
        } else {
            return Image(profile.photo)
        }
    }
}

@available(iOS 17, *)
struct InvestorDetailView: View {
    let profile: Profile

    var body: some View {
        VStack(spacing: 20) {
            Image(profile.photo)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)

            Text(profile.name)
                .font(.largeTitle.bold())

            Text("\(profile.title) @ \(profile.company)")
                .font(.title3)
                .foregroundColor(.secondary)

            Text(profile.bio)
                .padding()
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Investor Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    if #available(iOS 17, *) {
        ProfileCardView(profiles: [
            Profile(name: "Jess Wong", title: "CTO", company: "Neatflo", photo: "Jess Wong", raised: "$5M", role: "Co-Founder", bio: "Tech lead at Neatflo."),
            Profile(name: "Sarah Kim", title: "Partner", company: "Future Fund", photo: "sarah", raised: "$30M", role: "Angel Investor", bio: "Invests in early-stage startups."),
            Profile(name: "Tom Lee", title: "Angel", company: "SkyInvest", photo: "tom", raised: "$10M", role: "Angel Investor", bio: "AI & web3 angel.")
        ])
    } else {
        // Fallback on earlier versions
    }
}






