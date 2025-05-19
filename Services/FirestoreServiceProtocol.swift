//
//  FirestoreServiceProtocol.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

import Foundation
import SwiftData
import Combine

protocol NeatfloDataServiceProtocol: AnyObject {
    // MARK: - Core Operations
    @available(iOS 17, *)
    func fetchOpportunities() async throws -> [Opportunity]
    @available(iOS 17, *)
    func fetchOpportunitiesPublisher() -> AnyPublisher<[Opportunity], Error>
    
    // MARK: - CRUD Operations
    @available(iOS 17, *)
    func addOpportunity(_ opportunity: Opportunity) async throws
    @available(iOS 17, *)
    func updateOpportunity(_ opportunity: Opportunity) async throws
    func deleteOpportunity(id: UUID) async throws
    
    // MARK: - Advanced Queries
    @available(iOS 17, *)
    func fetchOpportunities(minMatchStrength: Double) async throws -> [Opportunity]
    @available(iOS 17, *)
    func fetchRecentOpportunities(limit: Int) async throws -> [Opportunity]
}

// MARK: - Default Implementations
extension NeatfloDataServiceProtocol {
    @available(iOS 17, *)
    func fetchOpportunitiesPublisher() -> AnyPublisher<[Opportunity], Error> {
        Future { [weak self] promise in
            Task { [weak self] in
                do {
                    let opportunities = try await self?.fetchOpportunities() ?? []
                    promise(.success(opportunities))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
