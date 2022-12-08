//
//  ListenOthersEnterStateUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseFirestore

protocol ListenOthersEnterStateUseCase {
    var otherIsEntered: PassthroughSubject<String, Never> { get }
    func removeListen()
    func listenOthersEnterState()
}
