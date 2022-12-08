//
//  DefaultUserHeartInfoRepository.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/07.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserHeartInfoRepository {
    
    func listenHeartInfo() async throws -> UserHeartInfo
    func updateHeart()
    
}

//final class DefaultUserHeartInfoRepository: UserHeartInfoRepository {
//    
//    let db = Firestore.firestore()
//    
//    func listenHeartInfo(@escaping ()) async throws -> UserHeartInfo {
//        let querySnapshot = db.collection("UserHeartInfo")
//            .document(Auth.auth().currentUser?.uid ?? "")
//            .addSnapshotListener { querySnapshot, err in
//                if err != nil {
//                    print(err ?? "")
//                    return
//                }
//                try? querySnapshot?.data(as: UserHeartInfoDTO.self)
//                
//                querySnapshot.
//            }
//        querySnapshot.
//    }
//    
//    func updateHeart() {
//        print("dd")
//    }
//    
//}
