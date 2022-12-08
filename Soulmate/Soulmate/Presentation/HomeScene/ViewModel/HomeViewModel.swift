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
    var showDetailVC: ((DetailPreviewViewModel) -> Void)?
}

final class HomeViewModel: ViewModelable {
    
    var cancellable = Set<AnyCancellable>()
    
    typealias Action = HomeViewModelAction
    var actions: Action?
    
    let mateRecommendationUseCase: MateRecommendationUseCase
    let downloadPictureUseCase: DownLoadPictureUseCase
    let uploadLocationUseCase: UpLoadLocationUseCase
    let getDistanceUseCase: GetDistanceUseCase
        
    
    @Published var matePreviewViewModelList = [HomePreviewViewModel]()
    
    @Published var currentLocation: Location? // 애는 첫 1회만 업댓시 바인딩해서 리프레시할거임, 그다음부턴 프로퍼티처럼 사용됨
    @Published var distance: Double
    
    struct Input {
        var didTappedRefreshButton: AnyPublisher<Void, Never>
        var didSelectedMateCollectionCell: AnyPublisher<Int, Never>
    }
    
    struct Output {
        var didRefreshedPreviewList: AnyPublisher<[HomePreviewViewModel], Never>
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
        
        self.distance = getDistanceUseCase.getDistance()
        
        self.bind()
    }

    func setActions(actions: Action) {
        self.actions = actions
    }
    
    func bind() {
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
            }
            .store(in: &cancellable)
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
        
        input.didTappedRefreshButton
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &cancellable)
        
        input.didSelectedMateCollectionCell
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.mateSelected(index: index)
            }
            .store(in: &cancellable)

        return Output(
            didRefreshedPreviewList: $matePreviewViewModelList.eraseToAnyPublisher()
        )
    }
    
    func refresh() {
        Task { [weak self] in
            guard let currentLocation = self?.currentLocation  else { return }
            let previewList = try await mateRecommendationUseCase
                .fetchDistanceFilteredRecommendedMate(from: currentLocation, distance: distance)
                        
            self?.matePreviewViewModelList = previewList.map { preview -> HomePreviewViewModel in
                guard let uid = preview.uid,
                      let imageKey = preview.imageKey,
                      let name = preview.name,
                      let birth = preview.birth,
                      let location = preview.location else { fatalError() }
                
                return HomePreviewViewModel(
                    uid: uid,
                    imageKey: imageKey,
                    name: name,
                    age: String(birth.toAge()),
                    distance: String(format: "%.2fkm", Location.distance(from: currentLocation, to: location))
                )
            }
                        
        }
    }
    
    func fetchImage(key: String) async throws -> Data? {
        return try await downloadPictureUseCase.downloadPhotoData(keyList: [key]).first
    }
    
    func mateSelected(index: Int) {
        let selectedMatePreviewViewModel = matePreviewViewModelList[index]
        let detailPreviewViewModel = DetailPreviewViewModel(
            uid: selectedMatePreviewViewModel.uid,
            name: selectedMatePreviewViewModel.name,
            age: selectedMatePreviewViewModel.age,
            distance: selectedMatePreviewViewModel.distance
        )
        actions?.showDetailVC?(detailPreviewViewModel)
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
