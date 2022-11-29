//
//  LoadChattingsRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import FirebaseFirestore

protocol LoadChattingsRepository {
    var startDocument: QueryDocumentSnapshot? { get }
    var lastDocument: QueryDocumentSnapshot? { get }
    
    func setStartDocument(_ doc: QueryDocumentSnapshot)
    func setLastDocument(_ doc: QueryDocumentSnapshot)
}
