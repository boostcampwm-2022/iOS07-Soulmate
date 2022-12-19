//
//  ModificationViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation
import FirebaseAuth
import Combine

struct ModificationViewModelActions {
    var didFinishModification: (() -> Void)?
}

class ModificationViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType

    typealias Action = ModificationViewModelActions
    
    struct Input {
        var didTappedSaveButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var didChangedDetailInfo: AnyPublisher<UserDetailInfo?, Never>
        var didChangedImageData: AnyPublisher<[Data?], Never>
        var didUploadAllInfo: AnyPublisher<Void, Never>
    }
    
    // MARK: UseCase
    
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    let uploadMyDetailInfoUseCase: UploadMyDetailInfoUseCase
    let uploadPictureUseCase: UploadPictureUseCase
    let uploadMyPreviewUseCase: UploadMyPreviewUseCase
    
    
    // MARK: Properties
    
    var actions: Action?
    var cancelables = Set<AnyCancellable>()
    var completionHandler: (() -> Void)?
    
    var userChatImageData: Data?
    
    @Published var userDetailInfo: UserDetailInfo?
    @Published var userDetailImageData: [Data?] = [nil, nil, nil, nil, nil]
    var didUploadAllInfo = PassthroughSubject<Void, Never>()
    
    // MARK: Configuration
    
    init(
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        downloadPictureUseCase: DownLoadPictureUseCase,
        uploadMyDetailInfoUseCase: UploadMyDetailInfoUseCase,
        uploadPictureUseCase: UploadPictureUseCase,
        uploadMyPreviewUseCase: UploadMyPreviewUseCase
    ) {
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
        self.downloadPictureUseCase = downloadPictureUseCase
        self.uploadMyDetailInfoUseCase = uploadMyDetailInfoUseCase
        self.uploadPictureUseCase = uploadPictureUseCase
        self.uploadMyPreviewUseCase = uploadMyPreviewUseCase
        
        loadInfo()
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        input.didTappedSaveButton
            .sink { [weak self] in
                self?.updateInfo()
            }
            .store(in: &cancelables)
        
        return Output(
            didChangedDetailInfo: $userDetailInfo.eraseToAnyPublisher(),
            didChangedImageData: $userDetailImageData.eraseToAnyPublisher(),
            didUploadAllInfo: didUploadAllInfo.eraseToAnyPublisher()
        )
    }
    
    // MARK: Logic
    
    func loadInfo() {
        Task { [weak self] in
            let userDetailInfo = try await downloadDetailInfoUseCase.downloadMyDetailInfo()
            self?.userDetailInfo = userDetailInfo
            
            guard let keyList = userDetailInfo.imageList else { return }
            self?.userDetailImageData = try await downloadPictureUseCase.downloadPhotoData(keyList: keyList)
        }
    }
    
    func updateInfo() {
        Task { [weak self] in
            
            guard var userDetailInfo = self?.userDetailInfo,
                  let chatImageData = self?.userChatImageData else { return }
            
            let chatImageKey = try await uploadPictureUseCase.uploadChatImageData(photoData: chatImageData)
            let ImageKeyList = try await uploadPictureUseCase.uploadPhotoData(photoData: userDetailImageData)
            
            let userPreview = UserPreview(
                gender: userDetailInfo.gender,
                name: userDetailInfo.nickName,
                birth: userDetailInfo.birthDay,
                imageKey: ImageKeyList.first,
                chatImageKey: chatImageKey
            )
            try await uploadMyPreviewUseCase.updatePreview(userPreview: userPreview)

            userDetailInfo.imageList = ImageKeyList
            try await uploadMyDetailInfoUseCase.uploadDetailInfo(registerUserInfo: userDetailInfo)
            
            self?.didUploadAllInfo.send(())
        }
    }
    
    func finishModification() {
        completionHandler?()
        actions?.didFinishModification?()
    }
}
