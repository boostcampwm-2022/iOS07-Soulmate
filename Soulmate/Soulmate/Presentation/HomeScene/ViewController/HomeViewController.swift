//
//  HomeViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit
import Combine
import CoreLocation

final class HomeViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    var locationManager: CLLocationManager?
    private var viewModel: HomeViewModel?
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    enum ItemKind: Hashable {
        case main(HomePreviewViewModel)
    }

    var refreshButtonTapSubject = PassthroughSubject<Void, Never>()
    var collectionViewSelectSubject = PassthroughSubject<Int, Never>()
    var tokenUpdateSubject = PassthroughSubject<String, Never>()
    
    // MARK: - UI
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var numOfHeartButton: UIButton = {
        let button = UIButton()
        button.setTitle("00", for: .normal)
        button.setTitleColor(UIColor.labelDarkGrey, for: .normal)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        self.view.addSubview(button)

        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.bounces = true
        collection.isPagingEnabled = false
        collection.backgroundColor = .clear
        self.view.addSubview(collection)
        return collection
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionKind, ItemKind>?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: HomeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
        
        configureLocationService()
        configureDataSource()
        
        updateToken()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !NetworkMonitor.shared.isConnected {
            showPopUp(title: "네트워크 접속 불가🕸️",
                      message: "네트워크 연결 상태를 확인해주세요.",
                      leftActionTitle: "취소",
                      rightActionTitle: "설정",
                      rightActionCompletion: { // 설정 켜기
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
        }
    }
}

// MARK: - Read UserDefault
private extension HomeViewController {
    
    func updateToken() {
        if let token = UserDefaults.standard.string(forKey: UserDefaultKey.fcmToken) {
            tokenUpdateSubject.send(token)
        }
    }
}

// MARK: - CLLocation
private extension HomeViewController {
    func configureLocationService() {
        locationManager = CLLocationManager()
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.distanceFilter = 2000
        locationManager?.allowsBackgroundLocationUpdates = true
                
        locationManager?.delegate = self
        
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
}

// MARK: - DataSource
private extension HomeViewController {
    func configureDataSource() {

        // MARK: Cell Registration
        
        let previewCellRegistration = UICollectionView.CellRegistration<PartnerCell, HomePreviewViewModel> { (cell, indexPath, identifier) in
            cell.fill(previewViewModel: identifier)
            Task { [weak self] in
                guard let data = try await self?.viewModel?.fetchImage(key: identifier.imageKey),
                      let uiImage = UIImage(data: data) else { return }

                await MainActor.run {
                    cell.fill(userImage: uiImage)
                }
            }
        }

        
        let footerViewRegistration = UICollectionView.SupplementaryRegistration
        <RecommendFooterView>(elementKind: RecommendFooterView.footerKind) { [weak self] supplementaryView, string, indexPath in
            supplementaryView.configureButtonHandler {
                self?.showPopUp(title: "다시한번 추천받기", message: "하트❤️ 10개가 소비되어요~", rightActionCompletion: {
                    self?.refreshButtonTapSubject.send(())
                })
            }
        }
        
        // MARK: DataSource Configuration        
        self.dataSource = UICollectionViewDiffableDataSource<SectionKind, ItemKind>(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .main(let previewViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: previewCellRegistration, for: indexPath, item: previewViewModel)
            }
        }
        
        self.dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerViewRegistration, for: indexPath)
        }

        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, ItemKind>()
        snapshot.appendSections(SectionKind.allCases)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.mainSectionLayout()
            default: fatalError()
            }
        }
    }
    
    private func mainSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(54))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: RecommendFooterView.footerKind,
            alignment: .bottom
        )
        footer.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.boundarySupplementaryItems = [footer]

        return section
    }
}

// MARK: - View Generators
private extension HomeViewController {
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: HomeViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                didTappedRefreshButton: refreshButtonTapSubject.eraseToAnyPublisher(),
                didSelectedMateCollectionCell: collectionViewSelectSubject.eraseToAnyPublisher(),
                didTappedHeartButton: numOfHeartButton.tapPublisher().eraseToAnyPublisher(),
                tokenUpdateEvent: tokenUpdateSubject.eraseToAnyPublisher()
            )
        )

        output.didRefreshedPreviewList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previewViewModelList in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append(previewViewModelList.map { return ItemKind.main($0) })
                self?.dataSource?.apply(snapshot, to: .main)
            }
            .store(in: &cancellables)
        
        output.didUpdatedHeartInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartInfo in
                guard let heart = heartInfo.heart else { return }
                self?.numOfHeartButton.setTitle("\(heart)", for: .normal)
            }
            .store(in: &cancellables)
    }
    
    func configureView() {
        view.backgroundColor = .white
        collectionView.delegate = self
    }
    
    func configureLayout() {
        logo.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.snp.top).offset(64)
            $0.width.equalTo(140)
        }

        numOfHeartButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalTo(logo.snp.centerY)
            $0.height.equalTo(28)
            $0.width.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }
    
    func setAuthAlertAction() {
         let authAlertController = UIAlertController(
            title: "위치 사용 권한이 필요합니다.",
            message: "위치 권한을 허용해야만 앱을 사용하실 수 있습니다.", preferredStyle: .alert
         )
         
         let getAuthAction = UIAlertAction(title: "설정", style: .default, handler: { (UIAlertAction) in
             if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                 UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
             }
         })
         authAlertController.addAction(getAuthAction)
         self.present(authAlertController, animated: true, completion: nil)
     }
}

// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            collectionViewSelectSubject.send(indexPath.row)
        default:
            fatalError("indexPath.section")
        }
    }
}

// MARK: - CL Delegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            guard let location = locations.last else { return }
            var locationInstance = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            viewModel?.updateLocation(location: locationInstance)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .notDetermined, .denied:
            manager.requestAlwaysAuthorization()
        }
    }
}
