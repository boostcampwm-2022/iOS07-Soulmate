//
//  HomeViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import Foundation
import Combine

import FirebaseAuth
import CoreLocation

struct HomeViewModelAction {
    var showDetailVC: ((UserPreview) -> Void)?
}

final class HomeViewModel {
    let networkDatabaseApi = FireStoreNetworkDatabaseApi()
    lazy var userPreviewRepository = DefaultUserPreviewRepository(networkDatabaseApi: networkDatabaseApi)
    lazy var downLoadPreviewUseCase = DefaultDownLoadPreviewUseCase(userPreviewRepository: userPreviewRepository)
    
    var cancellable = Set<AnyCancellable>()
    
    var actions: HomeViewModelAction?
    
    let mateRecommendationUseCase: MateRecommendationUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    
    @Published var recommendedMatePreviewList = [UserPreview]()
    
    struct Input {}
    
    struct Output {
        var isLocationAuthorized: AnyPublisher<String?, Never>
        var didRefreshedPreviewList: AnyPublisher<[UserPreview], Never>
    }
    
    init(mateRecommendationUseCase: MateRecommendationUseCase, downloadPictureUseCase: DownLoadPictureUseCase) {
        self.mateRecommendationUseCase = mateRecommendationUseCase
        self.downloadPictureUseCase = downloadPictureUseCase
    }

    func setActions(actions: HomeViewModelAction) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {
        
        let locationAuthPublisher = UserDefaults.standard
            .publisher(for: \.isLocationAuthorized)
            .eraseToAnyPublisher()
        
        let distancePublisher = UserDefaults.standard
            .publisher(for: \.distance)
            .eraseToAnyPublisher()
        
        if UserDefaults.standard.double(forKey: "distance") == 0 {
            UserDefaults.standard.set(20, forKey: "distance") // 초기값 설정
        }
        
        
        Publishers.CombineLatest(
            locationAuthPublisher.compactMap { $0 },
            distancePublisher
        )
            .sink { (auth, distance) in
                if auth == "yes" { // 위치 서비스 이용 설정된 경우
                    // 근데 여기서 아직 위치 설정이 안된 경우는??
                    self.refresh(distance: distance)
                }
                else { // 설정안된 경우는 앱을 진행 못하게 막아야 하나?
                    // 이부분은 여기랑 뷰컨에서 바인딩하는데 뷰컨에선 auth에 따라 위치 켜라고 알림
                    self.recommendedMatePreviewList.removeAll()
                }
            }
            .store(in: &cancellable)

        
        return Output(
            isLocationAuthorized: locationAuthPublisher,
            didRefreshedPreviewList: $recommendedMatePreviewList.eraseToAnyPublisher()
        )
    }
    
    func refresh(distance: Double) {
        Task { [weak self] in
            guard let self else { return }
            do {
                self.recommendedMatePreviewList = try await mateRecommendationUseCase.fetchDistanceFilteredRecommendedMate(distance: distance)
            } catch { // 초기에 자꾸 위치설정이 안된 경우 에러가 뜸... 초기값이 설정되고 리프레시 하게 어케하지?
                print(error)
            }
        }
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func mateSelected(index: Int) {
        actions?.showDetailVC?(recommendedMatePreviewList[index])
    }

}


extension UserDefaults {
    @objc dynamic var isLocationAuthorized: String? {
        return string(forKey: "isLocationAuthorized")
    }
    
    @objc dynamic var distance: Double {
        return double(forKey: "distance")
    }
}
