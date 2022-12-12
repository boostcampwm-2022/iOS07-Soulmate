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
    
    func token(of uid: String) async -> String? {
        let path = "UserToken/\(uid)"
        
        let tokenDoc = try? await networkDatabaseApi.read(
            table: path,
            documentID: uid,
            type: UserToken.self
        )
        
        
        return tokenDoc?.token
    }
    
    func sendChattingFCM(to name: String, message: String, uid: String) async {
        
        guard let token = await token(of: uid) else { return }
        
        let dto = FCMMessageSendDTO(
            title: name,
            body: message,
            data: "",
            to: token)
        
        let _ = await urlSessionAPI.post(
            dto,
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
