//
//  EnterStateRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import FirebaseFirestore

protocol EnterStateRepository {
    var othersEnterState: Bool { get set }
    func set(state: Bool, in chatRoomId: String, uid: String)
    func listenOtherEnterStateDocRef(in chatRoomId: String, othersId: String) -> DocumentReference
}
