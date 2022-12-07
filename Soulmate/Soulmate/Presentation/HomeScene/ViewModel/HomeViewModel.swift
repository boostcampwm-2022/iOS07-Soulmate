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
    
    var cancellable = Set<AnyCancellable>()
    
    var actions: HomeViewModelAction?
    
    let mateRecommendationUseCase: MateRecommendationUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    let uploadLocationUseCase: UpLoadLocationUseCase
    let getDistanceUseCase: GetDistanceUseCase
        
    @Published var recommendedMatePreviewList = [UserPreview]()
    
    @Published var currentLocation: Location? // 애는 첫 1회만 업댓시 바인딩해서 리프레시할거임, 그다음부턴 프로퍼티처럼 사용됨
    @Published var distance: Double
    
    struct Input {
    }
    
    struct Output {
        var didRefreshedPreviewList: AnyPublisher<[UserPreview], Never>
    }
    
    init(
        mateRecommendationUseCase: MateRecommendationUseCase,
        downloadPictureUseCase: DownLoadPictureUseCase,
        uploadLocationUseCase: UpLoadLocationUseCase,
        getDistanceUseCase: GetDistanceUseCase
    ) {
        self.mateRecommendationUseCase = mateRecommendationUseCase
        self.downloadPictureUseCase = downloadPictureUseCase
        self.uploadLocationUseCase = uploadLocationUseCase
        self.getDistanceUseCase = getDistanceUseCase
        
        // distance를 받아와서 초기화 해둬야함.
        if UserDefaults.standard.double(forKey: "distance") == 0 {
            UserDefaults.standard.set(20, forKey: "distance") // FIXME: 초기값 설정, 이것도 여기서 해주는건 아닌거같다!!!
        }
        distance = UserDefaults.standard.double(forKey: "distance")
    }

    func setActions(actions: HomeViewModelAction) {
        self.actions = actions
    }
    
    func transform(input: Input) -> Output {

        // auth에 따라 current location을 채워줄거임
//        input.didChangedLocationAuthorization
//            .sink { value in
//                // true: 알아서 current location이 업데이트 됨
//                // false: 위치를 사용하면 좋다는 alert 띄우고 유저디폴트에 있는지 살피고, 없으면 서버에서 가져오고 서버에도 없으면 alert 띄우기
//                // 서버에도 없다면?? 위치서비스를 사용하시라고 팝업을 띄울까? viewWillAppear 될때마다 키라고 쪼아야하나?
//                if !value {
//                    // 애는 여기서 currentLocation을 설정하고 리프레시 해줘도 ㄱㅊ나?
//                }
//            }
//            .store(in: &cancellable)

        getDistanceUseCase.getDistancePublisher()
            .assign(to: \.distance, on: self)
            .store(in: &cancellable)
        
        $currentLocation
            .compactMap { $0 }
            .first()
            .sink { value in
                self.refresh()
            }
            .store(in: &cancellable)
        
        $distance
            .dropFirst()
            .sink { [weak self] value in
                self?.refresh()
                print("distance updated \(value)")
            }
            .store(in: &cancellable)

        return Output(
            didRefreshedPreviewList: $recommendedMatePreviewList.eraseToAnyPublisher()
        )
    }
    
    func refresh() {
        Task { [weak self] in
            guard let currentLocation = self?.currentLocation,
                  let distance = self?.distance else { return }
            
            self?.recommendedMatePreviewList = try await mateRecommendationUseCase
                    .fetchDistanceFilteredRecommendedMate(from: currentLocation, distance: distance)
        }
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func mateSelected(index: Int) {
        actions?.showDetailVC?(recommendedMatePreviewList[index])
    }
    
    func updateLocation(location: Location) {
        Task {
            self.currentLocation = location
            try await uploadLocationUseCase.updateLocation(location: location)
        }
    }

}


extension UserDefaults {
    @objc dynamic var isLocationAuthorized: String? {
        return string(forKey: "isLocationAuthorized")
    }
    
    @objc dynamic var distance: Double {
        return double(forKey: "distance")
    }
    
    @objc dynamic var latestLocation: Data? {
        return data(forKey: "latestLocation")
    }
}
