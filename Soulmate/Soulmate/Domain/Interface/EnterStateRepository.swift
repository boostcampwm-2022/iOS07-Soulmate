//
//  EnterStateRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseFirestore

protocol EnterStateRepository {
    var othersEnterState: Bool { get set }
    var otherIsEntered: PassthroughSubject<String, Never> { get }
    
    func removeListen()
    func set(state: Bool, in chatRoomId: String, uid: String)
    func listenOtherEnterState(in chatRoomId: String, othersId: String)
}
