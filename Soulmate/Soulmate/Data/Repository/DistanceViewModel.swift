//
//  DistanceViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import Combine

struct DistanceViewModelActions {}

class DistanceViewModel: ViewModelable {
    
    typealias Action = DistanceViewModelActions
    var actions: Action?
    
    var cancellables = Set<AnyCancellable>()
    
    let setDistanceUseCase: SetDistanceUseCase
    let getDistanceUseCase: GetDistanceUseCase
    
    @Published var distance: Double
        
    struct Input {
        var didChangedSliderValue: AnyPublisher<Float, Never>
    }
    
    struct Output {
        var didChangedDistanceValue: AnyPublisher<Double, Never>
    }
    
    init(
        setDistanceUseCase: SetDistanceUseCase,
        getDistanceUseCase: GetDistanceUseCase
    ) {
        self.setDistanceUseCase = setDistanceUseCase
        self.getDistanceUseCase = getDistanceUseCase
        
        self.distance = getDistanceUseCase.getDistance()
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        input.didChangedSliderValue
            .map { value -> Double in
                switch value {
                case 0:
                    return 5
                case 1:
                    return 10
                case 2:
                    return 20
                case 3:
                    return 50
                case 4:
                    return 1000
                default:
                    fatalError()
                }
            }
            .assign(to: \.distance, on: self)
            .store(in: &cancellables)
        
        return Output(didChangedDistanceValue: $distance.eraseToAnyPublisher())
    }
    
    func finishDistanceSetting() {
        setDistanceUseCase.setDistance(distance: distance)
    }
}
