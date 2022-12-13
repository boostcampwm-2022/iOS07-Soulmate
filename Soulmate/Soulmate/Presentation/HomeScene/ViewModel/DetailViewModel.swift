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

final class DetailViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType

    typealias Action = DetailViewModelActions

    struct Input {
        var didTappedMateRegistrationButton: AnyPublisher<Void, Never>
    }

    struct Output {
        var didFetchedImageKeyList: AnyPublisher<[String]?, Never>
        var didFetchedPreview: AnyPublisher<DetailPreviewViewModel?, Never>
        var didFetchedGreeting: AnyPublisher<String?, Never>
        var didFetchedBasicInfo: AnyPublisher<DetailBasicInfoViewModel?, Never>
        var lessHeart: AnyPublisher<Void, Never>
    }
    
    // MARK: UseCase
    
    let downloadPictureUseCase: DownLoadPictureUseCase
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    let sendMateRequestUseCase: SendMateRequestUseCase
    let heartUpdateUseCase: HeartUpdateUseCase
    
    // MARK: Properties
    
    var actions: Action?
    var cancellables = Set<AnyCancellable>()

    @Published var imageKeyList: [String]?
    @Published var detailPreviewViewModel: DetailPreviewViewModel?
    @Published var greetingMessage: String?
    @Published var basicInfo: DetailBasicInfoViewModel?
    
    var lessHeartEventPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: Configuration
    
    init(
        downloadPictureUseCase: DownLoadPictureUseCase,
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        sendMateRequestUseCase: SendMateRequestUseCase,
        heartUpdateUseCase: HeartUpdateUseCase
    ) {
        self.downloadPictureUseCase = downloadPictureUseCase
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
        self.sendMateRequestUseCase = sendMateRequestUseCase
        self.heartUpdateUseCase = heartUpdateUseCase
    }
    
    func setActions(actions: Action) {
        self.actions = actions
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
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        
        input.didTappedMateRegistrationButton
            .sink { [weak self] _ in
                
                self?.sendMateRequest()
            }
            .store(in: &cancellables)
        
        return Output(
            didFetchedImageKeyList: $imageKeyList.eraseToAnyPublisher(),
            didFetchedPreview: $detailPreviewViewModel.eraseToAnyPublisher(),
            didFetchedGreeting: $greetingMessage.eraseToAnyPublisher(),
            didFetchedBasicInfo: $basicInfo.eraseToAnyPublisher(),
            lessHeart: lessHeartEventPublisher.eraseToAnyPublisher()
        )
    }
    
    // MARK: Logic
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func sendMateRequest() {
        Task {
            guard let mateId = detailPreviewViewModel?.uid else { return }
            do {
                try await heartUpdateUseCase.updateHeart(heart: -20)
                try await self.sendMateRequestUseCase.sendMateRequest(mateId: mateId)
            }
            catch HeartShopError.lessHeart {
                self.lessHeartEventPublisher.send(())
            }
            catch {
                print("error")
            }
        }
    }
}
