//
//  DIContainer.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/05.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    
    let container = Container()
    
    private init() {
        registerInfraStructure()
        registerRepository()
        registerUseCase()
        registerViewModel()
    }
    
    func registerInfraStructure() {
        // Infrastructure
        registerLocalKeyValueStorage()
        
        registerNetworkKeyValueStorageApi()
        
        registerNetworkDatabaseApi()
    }
    
    func registerRepository() {
        // DataLayer Repository
        registerProfilePhotoRepository()
        
        registerUserDetailInfoRepository()
        
        registerUserDefaultsRepository()
        
        registerUserPreviewRepository()
        
        registerImageCacheRepository()
        
        registerAuthRepository()
        
        registerMateRequestRepository()
        
        registerUserHeartInfoRepository()
    }
    
    func registerUseCase() {
        // Domain
        registerAuthUseCase()
        
        registerDefaultPhoneSignInUseCase()
        
        registerDownLoadDetailInfoUseCase()
        
        registerSignOutUseCase()
        
        registerRegisterStateValidateUseCase()
        
        registerUpLoadDetailInfoUseCase()
        
        registerUpLoadPictureUseCase()
                
        registerDownLoadPictureUseCase()
        
        registerUpLoadPreviewUseCase()
        
        registerDownLoadPreviewUseCase()
        
        registerUpLoadLocationUseCase()
        
        registerMateRecommendationUseCase()
        
        registerSetDistanceUseCase()
        
        registerGetDistanceUseCase()
        
        registerListenMateRequestUseCase()
        
        registerSendMateRequestUseCase()
        
        registerHeartUpdateUseCase()
        
        registerListenHeartUpdateUseCase()
    }
    
    func registerViewModel() {
        // Presentation Layer ViewModels
        registerLoginViewModel()
        
        registerPhoneNumberViewModel()
        
        registerCertificationViewModel()
        
        registerRegisterViewModel()
        
        registerHomeViewModel()
        
        registerDetailViewModel()

        registerMyPageViewModel()
        
        registerModificationViewModel()
        
        registerDistanceViewModel()
        
        registerHeartShopViewModel()
    }
    
    
}

extension DIContainer {
    // MARK: Register Infrastructure
    
    func registerLocalKeyValueStorage() {
        container.register(LocalKeyValueStorage.self) { _ in
            return UserDefaulsLocalKeyValueStorage()
        }
        .inObjectScope(.container)
    }
    
    func registerNetworkKeyValueStorageApi() {
        container.register(NetworkKeyValueStorageApi.self) { _ in
            return FirebaseNetworkKeyValueStorageApi()
        }
        .inObjectScope(.container)
    }
    
    func registerNetworkDatabaseApi() {
        container.register(NetworkDatabaseApi.self) { _ in
            return FireStoreNetworkDatabaseApi()
        }
        .inObjectScope(.container)
    }
}

extension DIContainer {
    // MARK: Register DataLayer Repository
    
    func registerProfilePhotoRepository() {
        container.register(ProfilePhotoRepository.self) { r in
            let networkKeyValueStorageApi = r.resolve(NetworkKeyValueStorageApi.self)!
            return DefaultProfilePhotoRepository(networkKeyValueStorageApi: networkKeyValueStorageApi)
        }
        .inObjectScope(.container)
    }
    
    func registerUserDetailInfoRepository() {
        container.register(UserDetailInfoRepository.self) { r in
            let networkDatabaseApi = r.resolve(NetworkDatabaseApi.self)!
            return DefaultUserDetailInfoRepository(networkDatabaseApi: networkDatabaseApi)
        }
        .inObjectScope(.container)
    }
    
    func registerUserDefaultsRepository() {
        container.register(UserDefaultsRepository.self) { r in
            let localKeyValueStorage = r.resolve(LocalKeyValueStorage.self)!
            return DefaultUserDefaultsRepository(localKeyValueStorage: localKeyValueStorage)
        }
        .inObjectScope(.container)
    }
    
    func registerUserPreviewRepository() {
        container.register(UserPreviewRepository.self) { r in
            let networkDatabaseApi = r.resolve(NetworkDatabaseApi.self)!
            return DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
        }
        .inObjectScope(.container)
    }
    
    func registerImageCacheRepository() {
        container.register(ImageCacheRepository.self) { r in
            return DefaultImageCacheRepository(imageCacheStorage: NSCacheImageCacheStorage.shared)
        }
        .inObjectScope(.container)
    }
    
    func registerAuthRepository() {
        container.register(AuthRepository.self) { _ in
            return DefaultAuthRepository()
        }
    }
    
    func registerMateRequestRepository() {
        container.register(MateRequestRepository.self) { r in
            return DefaultMateRquestRepository(
                networkDatabaseApi: r.resolve(NetworkDatabaseApi.self)!
            )
        }
    }
    
    func registerUserHeartInfoRepository() {
        container.register(UserHeartInfoRepository.self) { r in
            return DefaultUserHeartInfoRepository(networkDatabaseApi: r.resolve(NetworkDatabaseApi.self)!)
        }
    }
    
}

extension DIContainer {
    
    // MARK: Domain UseCase
    
    func registerAuthUseCase() {
        container.register(AuthUseCase.self) { _ in
            return DefaultAuthUseCase()
        }
        .inObjectScope(.container)
    }
    
    func registerDefaultPhoneSignInUseCase() {
        container.register(PhoneSignInUseCase.self) { r in
            return DefaultPhoneSignInUseCase(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerDownLoadDetailInfoUseCase() {
        container.register(DownLoadDetailInfoUseCase.self) { r in
            return DefaultDownLoadDetailInfoUseCase(
                userDetailInfoRepository: r.resolve(UserDetailInfoRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerSignOutUseCase() {
        container.register(SignOutUseCase.self) { r in
            return DefaultSignOutUseCase(authRepository: r.resolve(AuthRepository.self)!)
        }
        .inObjectScope(.container)
    }
    
    func registerRegisterStateValidateUseCase() {
        container.register(RegisterStateValidateUseCase.self) { _ in
            return DefaultRegisterStateValidateUseCase()
        }
        .inObjectScope(.container)
    }
    
    func registerUpLoadDetailInfoUseCase() {
        container.register(UploadMyDetailInfoUseCase.self) { r in
            return DefaultUploadMyDetailInfoUseCase(
                userDetailInfoRepository: r.resolve(UserDetailInfoRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerUpLoadPictureUseCase() {
        container.register(UploadPictureUseCase.self) { r in
            return DefaultUpLoadPictureUseCase(
                profilePhotoRepository: r.resolve(ProfilePhotoRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
        
    func registerDownLoadPictureUseCase() {
        container.register(DownLoadPictureUseCase.self) { r in
            let profilePhotoRepository = r.resolve(ProfilePhotoRepository.self)!
            let imageCacheRepository = r.resolve(ImageCacheRepository.self)!
            return DefaultDownLoadPictureUseCase(
                profilePhotoRepository: profilePhotoRepository,
                imageCacheRepository: imageCacheRepository
            )
        }
        .inObjectScope(.container)
    }
    
    func registerUpLoadPreviewUseCase() {
        container.register(UploadMyPreviewUseCase.self) { r in
            return DefaultUploadMyPreviewUseCase(
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerDownLoadPreviewUseCase() {
        container.register(DownLoadMyPreviewUseCase.self) { r in
            return DefaultDownLoadMyPreviewUseCase(
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
    }
    
    func registerUpLoadLocationUseCase() {
        container.register(UpLoadLocationUseCase.self) { r in
            return DefaultUpLoadLocationUseCase(
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerMateRecommendationUseCase() {
        container.register(MateRecommendationUseCase.self) { r in
            return DefaultMateRecommendationUseCase(
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerSetDistanceUseCase() {
        container.register(SetDistanceUseCase.self) { r in
            return DefaultSetDistanceUseCase(userDefaultRepository: r.resolve(UserDefaultsRepository.self)!)
        }
        .inObjectScope(.container)
    }
    
    func registerGetDistanceUseCase() {
        container.register(GetDistanceUseCase.self) { r in
            return DefaultGetDistanceUseCase(userDefaultRepository: r.resolve(UserDefaultsRepository.self)!)
        }
        .inObjectScope(.container)
    }
    
    func registerListenMateRequestUseCase() {
        container.register(ListenMateRequestUseCase.self) { r in
            return DefaultListenMateRequestUseCase(
                mateRequestRepository: r.resolve(MateRequestRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerSendMateRequestUseCase() {
        container.register(SendMateRequestUseCase.self) { r in
            return DefaultSendMateRequestUseCase(
                mateRequestRepository: r.resolve(MateRequestRepository.self)!,
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    func registerListenHeartUpdateUseCase() {
        container.register(ListenHeartUpdateUseCase.self) { r in
            return DefaultListenHeartUpdateUseCase(
                userHeartInfoRepository: r.resolve(UserHeartInfoRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerHeartUpdateUseCase() {
        container.register(HeartUpdateUseCase.self) { r in
            return DefaultHeartUpdateUseCase(
                userHeartInfoRepository: r.resolve(UserHeartInfoRepository.self)!,
                authRepository: r.resolve(AuthRepository.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    
}

extension DIContainer {
    // MARK: register Presentation Layer ViewModel
    
    func registerLoginViewModel() {
        container.register(LoginViewModel.self) { r in
            return LoginViewModel(
                downLoadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!,
                registerStateValidateUseCase: r.resolve(RegisterStateValidateUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerPhoneNumberViewModel() {
        container.register(PhoneNumberViewModel.self) { r in
            return PhoneNumberViewModel(
                phoneSignInUseCase: r.resolve(PhoneSignInUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerCertificationViewModel() {
        container.register(CertificationViewModel.self) { r in
            return CertificationViewModel(
                phoneSignInUseCase: r.resolve(PhoneSignInUseCase.self)!,
                registerStateValidateUseCase: r.resolve(RegisterStateValidateUseCase.self)!,
                downloadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerRegisterViewModel() {
        container.register(RegisterViewModel.self) { r in
            return RegisterViewModel(
                uploadDetailInfoUseCase: r.resolve(UploadMyDetailInfoUseCase.self)!,
                uploadPictureUseCase: r.resolve(UploadPictureUseCase.self)!,
                uploadPreviewUseCase: r.resolve(UploadMyPreviewUseCase.self)!,
                heartUpdateUseCase: r.resolve(HeartUpdateUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerHomeViewModel() {
        container.register(HomeViewModel.self) { r in
            return HomeViewModel(
                mateRecommendationUseCase: r.resolve(MateRecommendationUseCase.self)!,
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                uploadLocationUseCase: r.resolve(UpLoadLocationUseCase.self)!,
                getDistanceUseCase: r.resolve(GetDistanceUseCase.self)!,
                listenHeartUpdateUseCase: r.resolve(ListenHeartUpdateUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerDetailViewModel() {
        container.register(DetailViewModel.self) { r in
            return DetailViewModel(
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                downloadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!,
                sendMateRequestUseCase: r.resolve(SendMateRequestUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerMyPageViewModel() {
        container.register(MyPageViewModel.self) { r in
            return MyPageViewModel(
                downLoadPreviewUseCase: r.resolve(DownLoadMyPreviewUseCase.self)!,
                downLoadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                listenHeartUpdateUseCase: r.resolve(ListenHeartUpdateUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerModificationViewModel() {
        container.register(ModificationViewModel.self) { r in
            return ModificationViewModel(
                downloadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!,
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                uploadMyDetailInfoUseCase: r.resolve(UploadMyDetailInfoUseCase.self)!,
                uploadPictureUseCase: r.resolve(UploadPictureUseCase.self)!,
                uploadMyPreviewUseCase: r.resolve(UploadMyPreviewUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerDistanceViewModel() {
        container.register(DistanceViewModel.self) { r in
            return DistanceViewModel(
                setDistanceUseCase: r.resolve(SetDistanceUseCase.self)!,
                getDistanceUseCase: r.resolve(GetDistanceUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerHeartShopViewModel() {
        container.register(HeartShopViewModel.self) { r in
            return HeartShopViewModel(heartUpdateUseCase: r.resolve(HeartUpdateUseCase.self)!)
        }
    }
}
