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
}

class HeartShopViewModel: ViewModelable {
    // 현재 데이터 바인딩 없음
    typealias Action = HeartShopViewModelActions
    
    let quantities = [30, 50, 100]
    let prices = ["15,000원", "30,000원", "50,000원"]
    
    var heartShopUseCase: HeartShopUseCase?
    var actions: Action?
    var cancellables = Set<AnyCancellable>()
    var didFinishCharging = PassthroughSubject<Void, Never>()
    
    @Published var selectedCellNumber: Int?
    
    struct Input {
        var didTappedHeartCell: AnyPublisher<Int, Never>
        var didTappedChargeButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var didFinishCharging: AnyPublisher<Void, Never>
    }
    
    init(
        heartShopUseCase: HeartShopUseCase
    ) {
        self.heartShopUseCase = heartShopUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
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
    
    func chargeHeart(row: Int) {
        Task { [weak self] in
            switch row {
            case 1:
                await heartShopUseCase?.chargeHeart(heart: 30)
            case 2:
                await heartShopUseCase?.chargeHeart(heart: 50)
            case 3:
                await heartShopUseCase?.chargeHeart(heart: 100)
            default:
                break
            }
            self?.didFinishCharging.send(())
        }
    }
    
}
