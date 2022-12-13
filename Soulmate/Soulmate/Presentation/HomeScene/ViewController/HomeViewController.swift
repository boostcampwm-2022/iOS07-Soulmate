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
    
    var bag = Set<AnyCancellable>()
    var locationManager: CLLocationManager?
    private var viewModel: HomeViewModel?
    
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    enum ItemKind: Hashable {
        case main(HomePreviewViewModelWrapper)
    }

    var refreshButtonTapSubject = PassthroughSubject<Void, Never>()
    var collectionViewSelectSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - UI
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 18)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()

    
    private lazy var numOfHeartButton: UIButton = {
        let button = UIButton()
        button.setTitle("00", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
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
        
        configureDataSource()
        
        configureLocationService()
        
    }

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

// MARK: CollectionView Configuration

private extension HomeViewController {
    func configureDataSource() {

        // MARK: Cell Registration
        
        let previewCellRegistration = UICollectionView.CellRegistration<PartnerCell, HomePreviewViewModelWrapper> { (cell, indexPath, identifier) in
            guard let viewModel = identifier.previewViewModel else {
                cell.activateSkeleton()
                return
            }
            cell.deactivateSkeleton()
            cell.fill(previewViewModel: viewModel)
            Task { [weak self] in
                guard let data = try await self?.viewModel?.fetchImage(key: viewModel.imageKey),
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
        
        fakeSnapshot()
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

// MARK: CollectionView Skeleton Diffable Snapshot

private extension HomeViewController {
    
    func fakeSnapshot() {
        let estimatedNumberOfRows = Int(ceil(self.view.frame.height / (self.view.frame.width - 20)))
        var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
        var targetSource = (0..<estimatedNumberOfRows).map {
            return HomePreviewViewModelWrapper(index: $0)
        }
        snapshot.append(targetSource.map { return .main($0) })
        dataSource?.apply(snapshot, to: .main) { [weak self] in
            self?.collectionView.isScrollEnabled = false
            self?.collectionView.allowsSelection = false
        }
        collectionView.contentOffset.y = 0
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
                didTappedHeartButton: numOfHeartButton.tapPublisher().eraseToAnyPublisher()
            )
        )

        output.didRefreshedPreviewList
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previewViewModelList in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append(previewViewModelList.enumerated().map { index, value in
                    return ItemKind.main(HomePreviewViewModelWrapper(index: index, previewViewModel: value))
                })
                self?.dataSource?.apply(snapshot, to: .main) { [weak self] in
                    self?.collectionView.isScrollEnabled = true
                    self?.collectionView.allowsSelection = true
                }
            }
            .store(in: &bag)
        
        output.didUpdatedHeartInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartInfo in
                guard let heart = heartInfo.heart else { return }
                self?.numOfHeartButton.setTitle("\(heart)", for: .normal)
            }
            .store(in: &bag)
        
        output.didStartRefreshing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.fakeSnapshot()
            }
            .store(in: &bag)
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
            $0.height.equalTo(18)
        }
        
        numOfHeartButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.snp.top).offset(64)
            $0.height.equalTo(18)
            $0.width.equalTo(70)
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
