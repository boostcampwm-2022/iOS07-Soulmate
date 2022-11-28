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
    @Published var recommendedMateImageList = [Data]()
    
    struct Input {}
    
    struct Output {
        var didRefreshedPreviewList: AnyPublisher<[UserPreview], Never>
        var didRefreshedImageList: AnyPublisher<[Data], Never>
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
            didRefreshedPreviewList: $recommendedMatePreviewList.eraseToAnyPublisher(),
            didRefreshedImageList: $recommendedMateImageList.eraseToAnyPublisher()
        )
    }
    
    func refresh() {
        Task { [weak self] in
            guard let self else { return }
            
            // TODO: 지금은 10키로 내의 메이트를 가져오고 있음. 이거 사용자가 선택 가능하도록 수정하자
            self.recommendedMatePreviewList = try await mateRecommendationUseCase.fetchDistanceFilteredRecommendedMate(distance: 10)
            
            // 이미지를 셀 내부에서 받아올 것인가? 아니면 이런식으로 한번에 받아올 것인가???
            let imageKeyList = self.recommendedMatePreviewList.compactMap { $0.imageKey }
            self.recommendedMateImageList = try await downloadPictureUseCase.downloadPhotoData(keyList: imageKeyList)
        }
    }
    
    func mateSelected(index: Int) {
        actions?.showDetailVC?(recommendedMatePreviewList[index])
    }

}
