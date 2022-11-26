//
//  LoadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import FirebaseFirestore

protocol LoadChattingsUseCase {
    var initLoadedchattings: CurrentValueSubject<[Chat], Never> { get }
    var prevChattings: CurrentValueSubject<[Chat], Never> { get }
    var loadedPrevChattingCount: PassthroughSubject<Int, Never> { get }
    var startDocument: QueryDocumentSnapshot? { get set }
    var lastDocument: QueryDocumentSnapshot? { get set }
    
    func loadChattings()
    func loadPrevChattings()
}
