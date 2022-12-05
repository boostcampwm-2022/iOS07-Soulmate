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

class ModificationViewModel {
    
    var cancelables = Set<AnyCancellable>()
    
    var completionHandler: (() -> Void)?
    
    var actions: ModificationViewModelActions?
    
    @Published var userDetailInfo: RegisterUserInfo?
    @Published var userDetailImageData: [Data?] = [nil, nil, nil, nil, nil]
    var userChatImageData: Data?
    
    var didUploadAllInfo = PassthroughSubject<Void, Never>()
    
    let downloadDetailInfoUseCase: DownLoadDetailInfoUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    
    let uploadDetailInfoUseCase: UploadDetailInfoUseCase
    let uploadPictureUseCase: UploadPictureUseCase
    let uploadPreviewUseCase: UploadPreviewUseCase
    
    struct Input {
        var didTappedSaveButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var didChangedDetailInfo: AnyPublisher<RegisterUserInfo?, Never>
        var didChangedImageData: AnyPublisher<[Data?], Never>
        var didUploadAllInfo: AnyPublisher<Void, Never>
    }
    
    init(
        downloadDetailInfoUseCase: DownLoadDetailInfoUseCase,
        downloadPictureUseCase: DownLoadPictureUseCase,
        uploadDetailInfoUseCase: UploadDetailInfoUseCase,
        uploadPictureUseCase: UploadPictureUseCase,
        uploadPreviewUseCase: UploadPreviewUseCase
    ) {
        self.downloadDetailInfoUseCase = downloadDetailInfoUseCase
        self.downloadPictureUseCase = downloadPictureUseCase
        self.uploadDetailInfoUseCase = uploadDetailInfoUseCase
        self.uploadPictureUseCase = uploadPictureUseCase
        self.uploadPreviewUseCase = uploadPreviewUseCase
        
        loadInfo()
    }
    
    func setActions(actions: ModificationViewModelActions) {
        self.actions = actions
    }
    
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
    
    func loadInfo() {
        Task { [weak self] in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userDetailInfo = try await downloadDetailInfoUseCase.downloadDetailInfo(userUid: uid)
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
                chatImageKey: chatImageKey,
                heart: 30
            )
            try await uploadPreviewUseCase.uploadPreview(userPreview: userPreview)

            userDetailInfo.imageList = ImageKeyList
            try await uploadDetailInfoUseCase.uploadDetailInfo(registerUserInfo: userDetailInfo)
            
            self?.didUploadAllInfo.send(())
        }
    }
    
    func finishModification() {
        completionHandler?()
        actions?.didFinishModification?()
    }
}
