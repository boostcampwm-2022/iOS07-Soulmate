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
    var cancellables = Set<AnyCancellable>()
    
    typealias Action = DetailViewModelActions
    var actions: Action?
    
    let downloadPictureUseCase: DownLoadPictureUseCase
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    let sendMateRequestUseCase: SendMateRequestUseCase
    
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
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        sendMateRequestUseCase: SendMateRequestUseCase
    ) {
        self.downloadPictureUseCase = downloadPictureUseCase
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
        self.sendMateRequestUseCase = sendMateRequestUseCase
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
            didFetchedBasicInfo: $basicInfo.eraseToAnyPublisher()
        )
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func sendMateRequest() {
        // 대화 친구 신청 시 처리하는 로직 부분
        Task {
            guard let mateId = detailPreviewViewModel?.uid else { return }
            do {
                try await self.sendMateRequestUseCase.sendMateRequest(mateId: mateId)
                
            }
            catch {
                print("error")
            }
        }
    }
}
