//
//  DefaultUserPreviewRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

class DefaultUserPreviewRepository: UserPreviewRepository {
    
    let networkDatabaseApi: NetworkDatabaseApi
    let collectionTitle = "UserPreview"
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func fetchDistanceFilteredRecommendedPreviewList(
        userUid: String,
        userGender: GenderType,
        userLocation: Location,
        distance: Double
    ) async throws -> [UserPreview] {
        
        let fromPoint = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)

        return try await networkDatabaseApi.read(
            table: collectionTitle,
            constraints: [QueryEntity(field: "gender", value: userGender.rawValue, comparator: .isNotEqualTo)],
            type: UserPreviewDTO.self
        )
        .filter { dto in
            guard let documentID = dto.uid,
                  documentID != userUid,
                  let location = dto.location else { return false }
            
            let toPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
            return toPoint.distance(from: fromPoint) <= distance * 1000
        }
        .map {
            $0.toDomain()
        }
        
    }
    
    func fetchRecommendedPreviewList(
        userUid: String,
        userGender: GenderType
    ) async throws -> [UserPreview] {
        return try await networkDatabaseApi.read(
            table: collectionTitle,
            constraints: [QueryEntity(field: "gender", value: userGender.rawValue, comparator: .isNotEqualTo)],
            type: UserPreviewDTO.self
        )
        .filter { dto in
            guard let documentID = dto.uid,
                  documentID != userUid else { return false }
            return true
        }
        .map {
            $0.toDomain()
        }
    }
    
    func uploadPreview(userUid: String, userPreview: UserPreview) async throws {
        try await networkDatabaseApi.create(
            table: collectionTitle,
            documentID: userUid,
            data: userPreview.toDTO()
        )
    }
    
    func updateLocation(userUid: String, location: Location) async throws {
        try await networkDatabaseApi.update(
            table: collectionTitle,
            documentID: userUid,
            with: [
                "location": location.toGeoPoint()
            ]
        )
    }
    
    func downloadPreview(userUid: String) async throws -> UserPreview {
        return try await networkDatabaseApi.read(
            table: collectionTitle,
            documentID: userUid,
            type: UserPreviewDTO.self
        )
        .toDomain()
    }
}
