//
//  DefaultFCMRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Firebase

final class DefaultFCMRepository: FCMRepository {
    
    private let urlSessionAPI: URLSessionAPI
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(urlSessionAPI: URLSessionAPI, networkDatabaseApi: NetworkDatabaseApi) {
        self.urlSessionAPI = urlSessionAPI
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func sendChattingFCM(to name: String, message: String,  token: String) async {
        
        let _ = await urlSessionAPI.post(
            "",
            url: "https://fcm.googleapis.com/fcm/send",
            header: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": Bundle.main.serverKey
            ]
        )
    }
    
    func updateFCMToken(for uid: String, token: String) {
        
        let path = "UserToken"
        
        networkDatabaseApi.update(
            path: path,
            documentId: uid,
            with: ["token": token])
    }
}
