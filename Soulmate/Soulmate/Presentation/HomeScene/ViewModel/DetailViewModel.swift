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
    
    let downLoadPictureUseCase: DownLoadPictureUseCase
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    
    @Published var preview: UserPreview?
    @Published var distance: Int?
    @Published var greetingMessage: String?
    @Published var height: Int?
    @Published var mbti: Mbti?
    @Published var drinking: DrinkingType?
    @Published var smoking: SmokingType?
    
    @Published var imageDataList: [Data]?
    
    init(
        downLoadPictureUseCase: DownLoadPictureUseCase,
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    ) {
        self.downLoadPictureUseCase = downLoadPictureUseCase
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
    }
    
    func setUser(userPreview: UserPreview) {
        Task { [weak self] in
            guard let uid = userPreview.uid else { return }
            
            self?.preview = userPreview
            
            let detailInfo = try await downloadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
            self?.height = detailInfo.height
            self?.mbti = detailInfo.mbti
            self?.drinking = detailInfo.drinkingType
            self?.smoking = detailInfo.smokingType
            self?.greetingMessage = detailInfo.aboutMe
            
            if let imageKeyList = detailInfo.imageList {
                self?.imageDataList = try await downLoadPictureUseCase.downloadPhotoData(keyList: imageKeyList)
            }
        }
    }
    
    func setActions(actions: DetailViewModelActions) {
        self.actions = actions
    }

}

extension DetailViewModel {
    struct Input {
        var didTappedMateRegistrationButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var didFetchedImageDataList: AnyPublisher<[Data]?, Never>
        var didFetchedPreview: AnyPublisher<UserPreview?, Never>
        var didFetchedHeight: AnyPublisher<Int?, Never>
        var didFetchedMbti: AnyPublisher<Mbti?, Never>
        var didFetchedDrinking: AnyPublisher<DrinkingType?, Never>
        var didFetchedSmoking: AnyPublisher<SmokingType?, Never>
        var didFetchedGreeting: AnyPublisher<String?, Never>
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedMateRegistrationButton
            .sink { [weak self] _ in
                self?.registerMate()
            }
            .store(in: &cancellables)
        
        return Output(
            didFetchedImageDataList: $imageDataList.eraseToAnyPublisher(),
            didFetchedPreview: $preview.eraseToAnyPublisher(),
            didFetchedHeight: $height.eraseToAnyPublisher(),
            didFetchedMbti: $mbti.eraseToAnyPublisher(),
            didFetchedDrinking: $drinking.eraseToAnyPublisher(),
            didFetchedSmoking: $smoking.eraseToAnyPublisher(),
            didFetchedGreeting: $greetingMessage.eraseToAnyPublisher()
        )
    }
    
    func registerMate() {
        // 대화 친구 신청 시 처리하는 로직 부분
    }
}
