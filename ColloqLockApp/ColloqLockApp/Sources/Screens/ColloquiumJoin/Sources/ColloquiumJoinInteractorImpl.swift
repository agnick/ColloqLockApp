import Foundation
import FirebaseFirestore

protocol ColloquiumJoinInteractor {
    func validateColloqiumCode(_ code: String) async throws -> String
    func validateUser(withId id: String, requiredRole: String) async throws -> String
}

final class ColloquiumJoinInteractorImpl: ColloquiumJoinInteractor {
    
    // MARK: - Public Methods
    
    func validateColloqiumCode(_ code: String) async throws -> String {
        do {
            let snapshot = try await firestore
                .collection(FirestoreCollections.tests)
                .whereField("accessCode", isEqualTo: code)
                .getDocuments()
            
            print(snapshot.documents)
            
            guard let doc = snapshot.documents.first else {
                throw ColloquiumJoinError.codeNotFound
            }
            
            let data = doc.data()
            let now = Date()
            
            if let startTime = data["startTime"] as? Timestamp {
                let startDate = startTime.dateValue()
                if now < startDate {
                    throw ColloquiumJoinError.colloquiumNotStarted
                }
            }
            
            if let endTime = data["endTime"] as? Timestamp {
                let endDate = endTime.dateValue()
                if now > endDate {
                    throw ColloquiumJoinError.colloquiumEnded
                }
            }
            
            return doc.documentID
        } catch let error as ColloquiumJoinError {
            throw error
        } catch {
            throw ColloquiumJoinError.networkError
        }
    }
    
    func validateUser(withId id: String, requiredRole: String) async throws -> String {
        do {
            let snapshot = try await firestore
                .collection("users")
                .whereField("id", isEqualTo: id)
                .getDocuments()
            
            guard let doc = snapshot.documents.first else {
                throw UserValidationError.userNotFound
            }
            
            return doc.documentID
        } catch let error as UserValidationError {
            throw error
        } catch {
            throw UserValidationError.networkError
        }
    }
    
    // MARK: - Private Properties
    
    private let firestore = Firestore.firestore()
}

enum UserValidationError: Error {
    case userNotFound
    case invalidRole
    case networkError
}
