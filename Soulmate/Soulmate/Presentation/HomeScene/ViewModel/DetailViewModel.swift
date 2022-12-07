//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation
import Combine

struct DetailViewModelActions {
}

final class DetailViewModel {
    var cancellables = Set<AnyCancellable>()
    
    var actions: DetailViewModelActions?
    
    let downloadPictureUseCase: DownLoadPictureUseCase
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    
    struct Input {
        var didTappedMateRegistrationButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var didFetchedImageKeyList: AnyPublisher<[String]?, Never>
        var didFetchedPreview: AnyPublisher<DetailPreviewViewModel?, Never>
        var didFetchedGreeting: AnyPublisher<String?, Never>
        var didFetchedBasicInfo: AnyPublisher<DetailBasicInfoViewModel?, Never>
    }

    @Published var imageKeyList: [String]?
    @Published var detailPreviewViewModel: DetailPreviewViewModel?
    @Published var greetingMessage: String?
    @Published var basicInfo: DetailBasicInfoViewModel?
    

    
    init(
        downloadPictureUseCase: DownLoadPictureUseCase,
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    ) {
        self.downloadPictureUseCase = downloadPictureUseCase
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
    }
    
    func setUser(detailPreviewViewModel: DetailPreviewViewModel) {
        Task { [weak self] in
            let uid = detailPreviewViewModel.uid
            self?.detailPreviewViewModel = detailPreviewViewModel
            let detailInfo = try await downloadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
            
            guard let height = detailInfo.height,
                  let mbti = detailInfo.mbti?.toString(),
                  let drinking = detailInfo.drinkingType?.rawValue,
                  let smoking = detailInfo.smokingType?.rawValue,
                  let greetingMessage = detailInfo.aboutMe,
                  let imageKeyList = detailInfo.imageList else { return }

            self?.greetingMessage = greetingMessage
            self?.basicInfo = DetailBasicInfoViewModel(
                uid: uid,
                height: String(height),
                mbti: mbti,
                drink: drinking,
                smoke: smoking
            )
            self?.imageKeyList = imageKeyList
        }
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedMateRegistrationButton
            .sink { [weak self] _ in
                self?.registerMate()
            }
            .store(in: &cancellables)
        
        return Output(
            didFetchedImageKeyList: $imageKeyList.eraseToAnyPublisher(),
            didFetchedPreview: $detailPreviewViewModel.eraseToAnyPublisher(),
            didFetchedGreeting: $greetingMessage.eraseToAnyPublisher(),
            didFetchedBasicInfo: $basicInfo.eraseToAnyPublisher()
        )
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func registerMate() {
        // 대화 친구 신청 시 처리하는 로직 부분
    }
    
    func setActions(actions: DetailViewModelActions) {
        self.actions = actions
    }

}
