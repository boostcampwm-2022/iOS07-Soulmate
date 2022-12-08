//
//  ListenOthersEnterStateUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import FirebaseFirestore

protocol ListenOthersEnterStateUseCase {
    func removeListen()
    func listenOthersEnterState()
}
