//
//  DefaultUserPreviewRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore

class DefaultUserPreviewRepository: UserPreviewRepository {

    let networkDatabaseApi: NetworkDatabaseApi
    let collectionTitle = "UserPreview"
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func fetchDistanceFilteredRecommendedPreviewList(userLocation: Location, distance: Double) async throws -> [UserPreview] {
        let lat = 0.008993614533681
        let lon = 0.011261261261261 // 경도는 서울 기준으로 1km 당 잡았습니다.

        let lowerLat = userLocation.latitude - (lat * distance)
        let lowerLon = userLocation.longitude - (lon * distance)

        let greaterLat = userLocation.latitude + (lat * distance)
        let greaterLon = userLocation.longitude + (lon * distance)

        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        
        return try await networkDatabaseApi.read(
            table: collectionTitle,
            constraints: [
                QueryEntity(field: "location", value: lesserGeopoint, comparator: .isGreaterThan),
                QueryEntity(field: "location", value: greaterGeopoint, comparator: .isLessThan)
            ],
            type: UserPreviewDTO.self
        )
        .map {
            $0.toDomain()
        }
    }
    
    func fetchRecommendedPreviewList() async throws -> [UserPreview] {
        return try await networkDatabaseApi.read(
            table: collectionTitle,
            constraints: [QueryEntity(field: "gender", value: "여성", comparator: .isEqualTo)],
            type: UserPreviewDTO.self
        )
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
}
