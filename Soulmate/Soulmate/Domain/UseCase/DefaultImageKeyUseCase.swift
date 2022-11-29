//
//  DefaultImageKeyUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultImageKeyUseCase: ImageKeyUseCase {
    
    func imageKey(from uid: String) async -> String? {
        let db = Firestore.firestore()
        
        guard let doc = try? await db
            .collection("UserPreview")
            .document(uid)
            .getDocument() else { return nil }
        
        let key = doc.data()?["imageKey"] as? String
        
        return key
    }
}
