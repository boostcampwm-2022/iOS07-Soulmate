//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation
import Combine

final class DetailViewModel {
    private weak var coordinator: HomeCoordinator?
    var cancellables = Set<AnyCancellable>()
    var userInfo: RegisterUserInfo?
    
    @Published var photos: [String]?
    @Published var nickname: String?
    @Published var age: Int?
    @Published var distance: Int?
    @Published var greetingMessage: String?
    @Published var height: Int?
    @Published var mbti: String?
    @Published var drinking: String?
    @Published var smoking: String?
    
    func talkButtonTouched() {
        
    }
    
    init(userInfo: RegisterUserInfo, distance: Int, coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self.userInfo = userInfo
        self.distance = distance
    }

}

extension DetailViewModel {
    struct Input {
        var setPhotos: AnyPublisher<[String], Never>
        var setNickname: AnyPublisher<String, Never>
        var setAge: AnyPublisher<Date, Never>
        var setDistance: AnyPublisher<Int, Never>
        var setGreetingMessage: AnyPublisher<String, Never>
        var setHeight: AnyPublisher<Int, Never>
        var setMbti: AnyPublisher<Mbti, Never>
        var setDrinking: AnyPublisher<DrinkingType, Never>
        var setSmoking: AnyPublisher<SmokingType, Never>
        var didTouchedTalkButton: AnyPublisher<Void, Never>
    }

    struct Output { }
    
    func transform(input: Input) -> Output {
        input.setPhotos
            .compactMap { $0 }
            .assign(to: \.photos, on: self)
            .store(in: &cancellables)
        
        input.setNickname
            .compactMap { $0 }
            .assign(to: \.nickname, on: self)
            .store(in: &cancellables)
        
        input.setAge
            .compactMap { $0.toAge() }
            .assign(to: \.age, on: self)
            .store(in: &cancellables)
        
        input.setDistance
            .compactMap { $0 }
            .assign(to: \.distance, on: self)
            .store(in: &cancellables)
        
        input.setGreetingMessage
            .compactMap { $0 }
            .assign(to: \.greetingMessage, on: self)
            .store(in: &cancellables)
        
        input.setHeight
            .compactMap { $0 }
            .assign(to: \.height, on: self)
            .store(in: &cancellables)
        
        input.setMbti
            .compactMap { $0.toString() }
            .assign(to: \.mbti, on: self)
            .store(in: &cancellables)
        
        input.setDrinking
            .compactMap { $0.rawValue }
            .assign(to: \.drinking, on: self)
            .store(in: &cancellables)
        
        input.setSmoking
            .compactMap { $0.rawValue }
            .assign(to: \.smoking, on: self)
            .store(in: &cancellables)
        
        input.didTouchedTalkButton
            .sink { [weak self] _ in
                self?.talkButtonTouched()
            }
            .store(in: &cancellables)
        
        return Output()
    }
}
