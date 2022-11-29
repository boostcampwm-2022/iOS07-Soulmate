//
//  DefaultLoadChattingsRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import FirebaseFirestore

final class DefaultLoadChattingsRepository: LoadChattingsRepository {
    var startDocument: QueryDocumentSnapshot?
    var lastDocument: QueryDocumentSnapshot?
    
    func setStartDocument(_ doc: QueryDocumentSnapshot) {
        self.startDocument = doc
    }
    
    func setLastDocument(_ doc: QueryDocumentSnapshot) {
        self.lastDocument = doc
    }
}
