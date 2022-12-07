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
    var basicInfo: BasicInfoViewModel?
    
    var actions: DetailViewModelActions?
    
    let downloadPictureUseCase: DownLoadPictureUseCase
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    
    struct Input {
        var didTappedMateRegistrationButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var didFetchedImageKeyList: AnyPublisher<[String]?, Never>
        var didFetchedPreview: AnyPublisher<UserPreview?, Never>
        var didFetchedHeight: AnyPublisher<Int?, Never>
        var didFetchedMbti: AnyPublisher<Mbti?, Never>
        var didFetchedDrinking: AnyPublisher<DrinkingType?, Never>
        var didFetchedSmoking: AnyPublisher<SmokingType?, Never>
        var didFetchedGreeting: AnyPublisher<String?, Never>
    }
    
    @Published var preview: UserPreview?
    @Published var distance: Int?
    @Published var greetingMessage: String?
    @Published var height: Int?
    @Published var mbti: Mbti?
    @Published var drinking: DrinkingType?
    @Published var smoking: SmokingType?
    @Published var imageKeyList: [String]?
    
    init(
        downloadPictureUseCase: DownLoadPictureUseCase,
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    ) {
        self.downloadPictureUseCase = downloadPictureUseCase
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
            self?.imageKeyList = detailInfo.imageList
            
            guard let height = detailInfo.height,
                  let mbti = detailInfo.mbti,
                  let drink = detailInfo.drinkingType,
                  let smoke = detailInfo.smokingType else { return }
                        
            self?.basicInfo = BasicInfoViewModel(height: height, mbti: mbti, drink: drink, smoke: smoke)
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
            didFetchedPreview: $preview.eraseToAnyPublisher(),
            didFetchedHeight: $height.eraseToAnyPublisher(),
            didFetchedMbti: $mbti.eraseToAnyPublisher(),
            didFetchedDrinking: $drinking.eraseToAnyPublisher(),
            didFetchedSmoking: $smoking.eraseToAnyPublisher(),
            didFetchedGreeting: $greetingMessage.eraseToAnyPublisher()
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
