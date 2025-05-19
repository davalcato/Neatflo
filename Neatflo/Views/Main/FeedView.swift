//
//  FeedView.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import SwiftUI
import FirebaseFirestoreSwift

// MARK: - Model
struct Opportunity: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let company: String
    let summary: String
    let matchStrength: Double
    let timestamp: Date
}

// MARK: - ViewModel
final class FeedViewModel: ObservableObject {
    @Published var opportunities: [Opportunity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService.shared) {
        self.firestoreService = firestoreService
        loadOpportunities()
    }
    
    @MainActor
    func loadOpportunities() {
        isLoading = true
        Task {
            do {
                opportunities = try await firestoreService.fetchOpportunities()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func refresh() async {
        await loadOpportunities()
    }
}

// MARK: - View
struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var showingProfile = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.opportunities.isEmpty {
                    ProgressView()
                } else {
                    opportunityList
                }
                
                if let error = viewModel.errorMessage {
                    ErrorView(error: error)
                }
            }
            .navigationTitle("Your Matches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingProfile.toggle() }) {
                        Image(systemName: "person.circle")
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    private var opportunityList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.opportunities) { opportunity in
                    OpportunityCard(opportunity: opportunity)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Subviews
private struct OpportunityCard: View {
    let opportunity: Opportunity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(opportunity.title)
                        .font(.headline)
                    Text(opportunity.company)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                MatchStrengthIndicator(strength: opportunity.matchStrength)
            }
            
            Text(opportunity.summary)
                .font(.body)
                .lineLimit(3)
            
            HStack {
                Spacer()
                Text(opportunity.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct MatchStrengthIndicator: View {
    let strength: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .opacity(0.3)
                .foregroundStyle(.purple)
            
            Circle()
                .trim(from: 0, to: strength / 100)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .foregroundStyle(.purple)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(strength))%")
                .font(.system(size: 10, weight: .bold))
        }
        .frame(width: 36, height: 36)
    }
}

private struct ErrorView: View {
    let error: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(error)
                .padding()
        }
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
#Preview {
    FeedView()
}
