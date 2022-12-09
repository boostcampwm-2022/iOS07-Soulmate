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
    
    // MARK: Interface defined AssociatedType
    
    typealias Action = DistanceViewModelActions
    
    struct Input {
        var didChangedSliderValue: AnyPublisher<Float, Never>
    }
    
    struct Output {
        var didChangedDistanceValue: AnyPublisher<Double, Never>
    }
    
    // MARK: UseCase
    
    let setDistanceUseCase: SetDistanceUseCase
    let getDistanceUseCase: GetDistanceUseCase
    
    // MARK: Properties
    var actions: Action?
    var cancellables = Set<AnyCancellable>()
    
    @Published var distance: Double
        
    // MARK: Configuration
    
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
    
    // MARK: Data Bind
    
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
    
    // MARK: Logic
    
    func finishDistanceSetting() {
        setDistanceUseCase.setDistance(distance: distance)
    }
}
