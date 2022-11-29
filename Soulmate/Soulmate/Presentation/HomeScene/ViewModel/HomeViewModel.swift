//
//  HomeViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import Foundation
import Combine

struct HomeViewModelAction {
    var showDetailVC: ((UserPreview) -> Void)?
}

final class HomeViewModel {
    
    var cancellable = Set<AnyCancellable>()
    
    var actions: HomeViewModelAction?
    
    let mateRecommendationUseCase: MateRecommendationUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    
    @Published var recommendedMatePreviewList = [UserPreview]()
    
    struct Input {}
    
    struct Output {
        var didRefreshedPreviewList: AnyPublisher<[UserPreview], Never>
    }
    
    init(mateRecommendationUseCase: MateRecommendationUseCase, downloadPictureUseCase: DownLoadPictureUseCase) {
        self.mateRecommendationUseCase = mateRecommendationUseCase
        self.downloadPictureUseCase = downloadPictureUseCase
        
        refresh()
    }

    func setActions(actions: HomeViewModelAction) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        return Output(
            didRefreshedPreviewList: $recommendedMatePreviewList.eraseToAnyPublisher()
        )
    }
    
    func refresh() {
        Task { [weak self] in
            guard let self else { return }
            
            // TODO: 지금은 10키로 내의 메이트를 가져오고 있음. 이거 사용자가 선택 가능하도록 수정하자
            self.recommendedMatePreviewList = try await mateRecommendationUseCase.fetchDistanceFilteredRecommendedMate(distance: 10)
            
        }
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func mateSelected(index: Int) {
        actions?.showDetailVC?(recommendedMatePreviewList[index])
    }

}
