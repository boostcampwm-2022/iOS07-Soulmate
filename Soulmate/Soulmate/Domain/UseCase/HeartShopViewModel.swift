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

class HeartShopViewModel {
    // 현재 데이터 바인딩 없음
    
    let quantities = [30, 50, 100]
    let prices = ["15,000원", "30,000원", "50,000원"]
    
    var heartShopUseCase: HeartShopUseCase?
    var actions: HeartShopViewModelActions?
    var cancellables = Set<AnyCancellable>()
    var didFinishCharging = PassthroughSubject<Void, Never>()
    var completionHandler: (() -> Void)?
    
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
    
    func setActions(actions: HeartShopViewModelActions) {
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
        Task {
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
            didFinishCharging.send(())
            await MainActor.run {
                actions?.chargeFinished?()
            }
        }
    }
    
}
