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
    var showSignOutFlow: (() -> Void)?
}

class MyPageViewModel: ViewModelable {
    
    // MARK: Interface defined AssociatedType

    typealias Action = MyPageViewModelActions
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var didTappedMyInfoEditButton: AnyPublisher<Void, Never>
        var didTappedHeartShopButton: AnyPublisher<Void, Never>
        var didTappedMenuCell: AnyPublisher<Int, Never>
    }
    
    struct Output {
        var didUpdatedPreview: AnyPublisher<UserPreview?, Never>
        var didUpdatedImage: AnyPublisher<Data?, Never>
        var didUpdatedHeartInfo: AnyPublisher<UserHeartInfo?, Never>
    }
    
    // MARK: UseCase

    let downLoadMyPreviewUseCase: DownLoadMyPreviewUseCase
    let downLoadPictureUseCase: DownLoadPictureUseCase
    let listenHeartUpdateUseCase: ListenHeartUpdateUseCase
    let signOutUseCase: SignOutUseCase
    
    // MARK: Properties
    
    var actions: Action?
    var cancellables = Set<AnyCancellable>()
    
    let symbols = ["myPageHeart", "myPagePersonalInfo", "distance", "myPagePin", "signOut", ""]
    let titles = ["하트샵 가기", "개인정보 처리방침", "거리 설정하기", "버전정보", "로그아웃", "회원탈퇴"]
    let subTexts = ["", "", "", "v 3.2.20", "", ""]
    
    @Published var userProfileImage: Data?
    @Published var userProfileInfo: UserPreview?
    @Published var heartInfo: UserHeartInfo?
    
    // MARK: Configuration
    
    init(
        downLoadPreviewUseCase: DownLoadMyPreviewUseCase,
        downLoadPictureUseCase: DownLoadPictureUseCase,
        listenHeartUpdateUseCase: ListenHeartUpdateUseCase,
        signOutUseCase: SignOutUseCase
    ) {
        self.downLoadMyPreviewUseCase = downLoadPreviewUseCase
        self.downLoadPictureUseCase = downLoadPictureUseCase
        self.listenHeartUpdateUseCase = listenHeartUpdateUseCase
        self.signOutUseCase = signOutUseCase
        
        loadInfo()
    }
    
    func setActions(actions: Action) {
        self.actions = actions
    }
    
    // MARK: Data Bind
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .sink { [weak self] in
                self?.listenHeartUpdateUseCase.listenHeartUpdate()
            }
            .store(in: &cancellables)
                
        listenHeartUpdateUseCase.heartInfoSubject
            .sink { [weak self] value in
                self?.heartInfo = value
            }
            .store(in: &cancellables)
        
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
                case 4:
                    do {
                        try self?.signOutUseCase.signOut()
                    } catch {
                        fatalError("SignOut error")
                    }
                    self?.actions?.showSignOutFlow?()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        return Output(
            didUpdatedPreview: $userProfileInfo.eraseToAnyPublisher(),
            didUpdatedImage: $userProfileImage.eraseToAnyPublisher(),
            didUpdatedHeartInfo: $heartInfo.eraseToAnyPublisher()
        )
    }
    
    // MARK: Logic
    
    func loadInfo() {
        Task { [weak self] in
            let preview = try await downLoadMyPreviewUseCase.downloadPreview()
            self?.userProfileInfo = preview
            
            guard let imageKey = preview.imageKey else { return }
            self?.userProfileImage = try await downLoadPictureUseCase.downloadPhotoData(keyList: [imageKey])[0]
        }
    }
    
}
