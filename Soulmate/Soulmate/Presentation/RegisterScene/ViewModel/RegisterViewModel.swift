//
//  RegisterViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/21.
//

import Foundation
import Combine

struct RegisterViewModelAction {
    var quitRegister: (() -> Void)?
    var finishRegister: (() -> Void)?
}

class RegisterViewModel {
    
    var actions: RegisterViewModelAction?
    
    var bag = Set<AnyCancellable>()
    
    @Published var genderIndex: Int?
    @Published var nickName: String?
    @Published var height: String = String()
    @Published var birth: Date = Date()
    @Published var mbti: String?
    @Published var smokingIndex: Int?
    @Published var drinkingIndex: Int?
    @Published var introduction: String?
    @Published var photoData: [Data?] = [nil, nil, nil, nil, nil]
    
    struct Input {
        var didChangedPageIndex: AnyPublisher<Int, Never>
        var didChangedGenderIndex: AnyPublisher<Int?, Never>
        var didChangedNickNameValue: AnyPublisher<String?, Never>
        var didChangedHeightValue: AnyPublisher<String, Never>
        var didChangedBirthValue: AnyPublisher<Date, Never>
        var didChangedMbtiValue: AnyPublisher<String?, Never>
        var didChangedSmokingIndex: AnyPublisher<Int?, Never>
        var didChangedDrinkingIndex: AnyPublisher<Int?, Never>
        var didChangedIntroductionValue: AnyPublisher<String?, Never>
        var didChangedImageListValue: AnyPublisher<[Data?], Never>
        var didFinishedRegister: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    func setActions(actions: RegisterViewModelAction) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let valueChangedInCurrentPage = PassthroughSubject<Bool, Never>()
        let valueInChangedPage = input.didChangedPageIndex
            .map { [weak self] index in
                guard let self else { return true }
                switch index {
                case 0: return self.genderIndex != nil
                case 1: return self.nickName != nil
                case 4: return self.mbti != nil
                case 5: return self.smokingIndex != nil
                case 6: return self.drinkingIndex != nil
                case 7: return self.introduction != nil
                case 8: return self.photoData.allSatisfy { $0 != nil }
                default: return true
                }
            }
            .eraseToAnyPublisher()
        
        input.didChangedGenderIndex
            .sink { value in
                self.genderIndex = value
                valueChangedInCurrentPage.send(value != nil)
            }
            .store(in: &bag)

        input.didChangedNickNameValue
            .sink { value in
                self.nickName = value
                valueChangedInCurrentPage.send(value != nil && !value!.isEmpty)
            }
            .store(in: &bag)
        
        input.didChangedHeightValue
            .assign(to: \.height, on: self)
            .store(in: &bag)
        
        input.didChangedBirthValue
            .assign(to: \.birth, on: self)
            .store(in: &bag)
        
        input.didChangedMbtiValue
            .sink { value in
                self.mbti = value
                valueChangedInCurrentPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedSmokingIndex
            .sink { value in
                self.smokingIndex = value
                valueChangedInCurrentPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedDrinkingIndex
            .sink { value in
                self.drinkingIndex = value
                valueChangedInCurrentPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedIntroductionValue
            .sink { value in
                self.introduction = value
                valueChangedInCurrentPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedImageListValue
            .sink { value in
                self.photoData = value
                valueChangedInCurrentPage.send(value.allSatisfy { $0 != nil })
            }
            .store(in: &bag)
        
        input.didFinishedRegister
            .sink { [weak self] _ in
                self?.register()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = valueChangedInCurrentPage.merge(with: valueInChangedPage).eraseToAnyPublisher()

        
        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
    
    func quit() {
        actions?.quitRegister?()
    }
    
    func register() {
        guard let genderIndex = genderIndex,
              let nickName = nickName,
              let smokingIndex = smokingIndex,
              let drinkingIndex = drinkingIndex,
              let introduction = introduction else { return }
        
        let userInfo = RegisterUserInfo(
            id: "hihi",
            gender: GenderType.allCases[genderIndex],
            nickName: nickName, height: Int(height),
            smokingType: SmokingType.allCases[smokingIndex],
            drinkingType: DrinkingType.allCases[drinkingIndex],
            aboutMe: introduction
        )
        
        print(userInfo)
        actions?.finishRegister?()
    }
}

