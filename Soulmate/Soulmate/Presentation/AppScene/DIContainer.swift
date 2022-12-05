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
    
}

extension DIContainer {
    
    // MARK: Domain UseCase
    
    func registerAuthUseCase() {
        container.register(AuthUseCase.self) { _ in
            return DefaultAuthUseCase()
        }
    }
    
    func registerDefaultPhoneSignInUseCase() {
        container.register(DefaultPhoneSignInUseCase.self) { r in
            let userDefaultsRepository = r.resolve(UserDefaultsRepository.self)!
            return DefaultPhoneSignInUseCase(userDefaultsRepository: userDefaultsRepository)
        }
        .inObjectScope(.container)
    }
    
    func registerDownLoadDetailInfoUseCase() {
        container.register(DownLoadDetailInfoUseCase.self) { r in
            let userDetailInfoRepository = r.resolve(UserDetailInfoRepository.self)!
            return DefaultDownLoadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        }
        .inObjectScope(.container)
    }
    
    func registerSignOutUseCase() {
        container.register(SignOutUseCase.self) { r in
            return DefaultSignOutUseCase()
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
        container.register(UploadDetailInfoUseCase.self) { r in
            let userDetailInfoRepository = r.resolve(UserDetailInfoRepository.self)!
            return DefaultUploadDetailInfoUseCase(userDetailInfoRepository: userDetailInfoRepository)
        }
        .inObjectScope(.container)
    }
    
    func registerUpLoadPictureUseCase() {
        container.register(UploadPictureUseCase.self) { r in
            let profilePhotoRepository = r.resolve(ProfilePhotoRepository.self)!
            return DefaultUpLoadPictureUseCase(profilePhotoRepository: profilePhotoRepository)
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
        container.register(UploadPreviewUseCase.self) { r in
            let userPreviewRepository = r.resolve(UserPreviewRepository.self)!
            return DefaultUploadPreviewUseCase(userPreviewRepository: userPreviewRepository)
        }
        .inObjectScope(.container)
    }
    
    func registerDownLoadPreviewUseCase() {
        container.register(DownLoadPreviewUseCase.self) { r in
            return DefaultDownLoadPreviewUseCase(userPreviewRepository: r.resolve(UserPreviewRepository.self)!)
        }
    }
    
    func registerUpLoadLocationUseCase() {
        container.register(UpLoadLocationUseCase.self) { r in
            let userPreviewRepository = r.resolve(UserPreviewRepository.self)!
            let userDefaultsRepository = r.resolve(UserDefaultsRepository.self)!
            return DefaultUpLoadLocationUseCase(
                userPreviewRepository: userPreviewRepository,
                userDefaultsRepository: userDefaultsRepository
            )
        }
        .inObjectScope(.container)
    }
    
    func registerMateRecommendationUseCase() {
        container.register(MateRecommendationUseCase.self) { r in
            return DefaultMateRecommendationUseCase(
                userPreviewRepository: r.resolve(UserPreviewRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }
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
                uploadDetailInfoUseCase: r.resolve(UploadDetailInfoUseCase.self)!,
                uploadPictureUseCase: r.resolve(UploadPictureUseCase.self)!,
                uploadPreviewUseCase: r.resolve(UploadPreviewUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerHomeViewModel() {
        container.register(HomeViewModel.self) { r in
            return HomeViewModel(
                mateRecommendationUseCase: r.resolve(MateRecommendationUseCase.self)!,
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!
            )
        }
        .inObjectScope(.graph)
    }
    
    func registerDetailViewModel() {
        container.register(DetailViewModel.self) { r in
            return DetailViewModel(
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                downloadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!
            )
        }
    }
    
    func registerMyPageViewModel() {
        container.register(MyPageViewModel.self) { r in
            return MyPageViewModel(
                downLoadPreviewUseCase: r.resolve(DownLoadPreviewUseCase.self)!,
                downLoadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!
            )
        }
    }
    
    func registerModificationViewModel() {
        container.register(ModificationViewModel.self) { r in
            return ModificationViewModel(
                downloadDetailInfoUseCase: r.resolve(DownLoadDetailInfoUseCase.self)!,
                downloadPictureUseCase: r.resolve(DownLoadPictureUseCase.self)!,
                uploadDetailInfoUseCase: r.resolve(UploadDetailInfoUseCase.self)!,
                uploadPictureUseCase: r.resolve(UploadPictureUseCase.self)!,
                uploadPreviewUseCase: r.resolve(UploadPreviewUseCase.self)!
            )
        }
    }
}
