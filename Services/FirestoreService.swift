//
//  FirestoreService.swift
//  Neatflo
//
//  Created by Ethan Hunt on 4/26/25.
//

//// FirestoreService.swift
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//final class FirestoreService: FirestoreServiceProtocol {
//    static let shared = FirestoreService()
//    private let db = Firestore.firestore()
//    
//    func fetchOpportunities() async throws -> [Opportunity] {
//        let snapshot = try await db
//            .collection("opportunities")
//            .order(by: "timestamp", descending: true)
//            .getDocuments()
//        
//        return try snapshot.documents.map { document in
//            try document.data(as: Opportunity.self)
//        }
//    }
//}
