//
//  HeartShopViewModel.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/05.
//

import Foundation
import Combine

struct HeartShopViewModelActions {
    var quitHeartShop: (() -> Void)?
    var chargeFinished: (() -> Void)?
}

class HeartShopViewModel: ViewModelable {

    // MARK: Interface defined AssociatedType
    
    typealias Action = HeartShopViewModelActions
    
    struct Input {
        var didTappedHeartCell: AnyPublisher<Int, Never>
        var didTappedChargeButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var didFinishCharging: AnyPublisher<Void, Never>
    }
    
    // MARK: UseCase

    let heartUpdateUseCase: HeartUpdateUseCase
    
    // MARK: Properties
    
    var actions: Action?
    var cancellables = Set<AnyCancellable>()
    var completionHandler: (() -> Void)?

    let quantities = [30, 50, 100]
    let prices = ["15,000원", "30,000원", "50,000원"]
    
    var didFinishCharging = PassthroughSubject<Void, Never>()
    @Published var selectedCellNumber: Int?
    
    // MARK: Configuration
    
    init(
        heartUpdateUseCase: HeartUpdateUseCase
    ) {
        self.heartUpdateUseCase = heartUpdateUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        
        input.didTappedHeartCell
            .sink { [weak self] in
                self?.selectedCellNumber = $0
            }
            .store(in: &cancellables)
            
        
        input.didTappedChargeButton
            .sink { [weak self] in
                self?.chargeHeart(row: self?.selectedCellNumber ?? 0)
            }
            .store(in: &cancellables)
        
        return Output(didFinishCharging: didFinishCharging.eraseToAnyPublisher())
    }
    
    // MARK: Logic

    func chargeHeart(row: Int) {
        Task {
            switch row {
            case 1:
                try? await heartUpdateUseCase.updateHeart(heart: 30)
            case 2:
                try? await heartUpdateUseCase.updateHeart(heart: 50)
            case 3:
                try? await heartUpdateUseCase.updateHeart(heart: 100)
            default:
                break
            }
            await MainActor.run {
                actions?.chargeFinished?()
            }
        }
    }
    
}
