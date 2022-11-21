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
    @Published var smokingIndex: Int?
    @Published var drinkingIndex: Int?
    @Published var introduction: String?
    
    struct Input {
        var didChangedPageIndex: AnyPublisher<Int, Never>
        var didChangedGenderIndex: AnyPublisher<Int?, Never>
        var didChangedNickNameValue: AnyPublisher<String?, Never>
        var didChangedHeightValue: AnyPublisher<String, Never>
        var didChangedBirthValue: AnyPublisher<Date, Never>
        var didChangedSmokingIndex: AnyPublisher<Int?, Never>
        var didChangedDrinkingIndex: AnyPublisher<Int?, Never>
        var didChangedIntroductionValue: AnyPublisher<String?, Never>
        var didFinishedRegister: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    func setActions(actions: RegisterViewModelAction) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let valueChangedInPage = PassthroughSubject<Bool, Never>()
        let valueInPageChange = input.didChangedPageIndex
            .map { [weak self] index in
                switch index {
                case 0: return self?.genderIndex != nil
                case 1: return self?.nickName != nil
                case 4: return self?.smokingIndex != nil
                case 5: return self?.drinkingIndex != nil
                case 6: return self?.introduction != nil
                default:
                    return true
                }
            }
            .eraseToAnyPublisher() //페이지가 바뀌고 value가 없을 때
        
        input.didChangedGenderIndex
            .sink { value in
                self.genderIndex = value
                valueChangedInPage.send(value != nil)
            }
            .store(in: &bag)

        input.didChangedNickNameValue
            .sink { value in
                self.nickName = value
                valueChangedInPage.send(value != nil && !value!.isEmpty)
            }
            .store(in: &bag)
        
        input.didChangedHeightValue
            .assign(to: \.height, on: self)
            .store(in: &bag)
        
        input.didChangedBirthValue
            .assign(to: \.birth, on: self)
            .store(in: &bag)
        
        input.didChangedSmokingIndex
            .sink { value in
                self.smokingIndex = value
                valueChangedInPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedDrinkingIndex
            .sink { value in
                self.drinkingIndex = value
                valueChangedInPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didChangedIntroductionValue
            .sink { value in
                self.introduction = value
                valueChangedInPage.send(value != nil)
            }
            .store(in: &bag)
        
        input.didFinishedRegister
            .sink { [weak self] _ in
                self?.register()
            }
            .store(in: &bag)
        
        let isNextButtonEnabled = valueChangedInPage.merge(with: valueInPageChange).eraseToAnyPublisher()

        
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
