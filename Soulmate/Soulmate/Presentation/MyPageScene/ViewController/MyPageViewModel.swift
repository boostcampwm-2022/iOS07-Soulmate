//
//  MyPageViewModel.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/23.
//

import Foundation
import FirebaseAuth
import Combine

struct MyPageViewModelActions {
    var showMyInfoEditFlow: ((@escaping () -> Void) -> Void)?
    var showServiceTermFlow: (() -> Void)?
    var showHeartShopFlow: (() -> Void)?
    var showDistanceFlow: (() -> Void)?
}

class MyPageViewModel {
    
    let downLoadPreviewUseCase: DownLoadPreviewUseCase
    let downLoadPictureUseCase: DownLoadPictureUseCase
    
    let symbols = ["myPageHeart", "myPagePersonalInfo", "distance", "myPagePin"]
    let titles = ["하트샵 가기", "개인정보 처리방침", "거리 설정하기", "버전정보"]
    let subTexts = ["", "", "", "v 3.2.20"]
    
    var actions: MyPageViewModelActions?
    var cancellables = Set<AnyCancellable>()
    
    @Published var userProfileImage: Data?
    @Published var userProfileInfo: UserPreview?
    
    struct Input {
        var didTappedMyInfoEditButton: AnyPublisher<Void, Never>
        var didTappedHeartShopButton: AnyPublisher<Void, Never>
        var didTappedMenuCell: AnyPublisher<Int, Never>
    }
    
    struct Output {
        var didUpdatedPreview: AnyPublisher<UserPreview?, Never>
        var didUpdatedImage: AnyPublisher<Data?, Never>
    }
    
    init(
        downLoadPreviewUseCase: DownLoadPreviewUseCase,
        downLoadPictureUseCase: DownLoadPictureUseCase
    ) {
        self.downLoadPreviewUseCase = downLoadPreviewUseCase
        self.downLoadPictureUseCase = downLoadPictureUseCase
        
        // 여기서 해주고 내정보 수정에서 save하고 빠져나올때마다 계속 업댓해주자
        loadInfo()
    }
    
    func setActions(actions: MyPageViewModelActions) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        input.didTappedHeartShopButton
            .sink { [weak self] in
                self?.actions?.showHeartShopFlow?()
            }
            .store(in: &cancellables)
        
        input.didTappedMyInfoEditButton
            .sink { [weak self] in
                self?.actions?.showMyInfoEditFlow? { [weak self] in
                    self?.loadInfo()
                }
            }
            .store(in: &cancellables)
        
        input.didTappedMenuCell
            .sink { [weak self] in
                switch $0 {
                case 0:
                    self?.actions?.showHeartShopFlow?()
                case 1:
                    self?.actions?.showServiceTermFlow?()
                case 2:
                    self?.actions?.showDistanceFlow?()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        return Output(
            didUpdatedPreview: $userProfileInfo.eraseToAnyPublisher(),
            didUpdatedImage: $userProfileImage.eraseToAnyPublisher()
        )
        
    }
    
    func loadInfo() {
        Task { [weak self] in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let preview = try await downLoadPreviewUseCase.downloadPreview(userUid: uid)
            self?.userProfileInfo = preview
            
            guard let imageKey = preview.imageKey else { return }
            self?.userProfileImage = try await downLoadPictureUseCase.downloadPhotoData(keyList: [imageKey])[0]
        }
    }
    
}
