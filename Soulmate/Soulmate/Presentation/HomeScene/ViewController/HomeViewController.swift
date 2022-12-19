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
    
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModel?
    
    // MARK: - DIffable DataSource
    enum SectionKind: Int, CaseIterable {
        case main
    }
    
    enum ItemKind: Hashable {
        case main(HomePreviewViewModelWrapper)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionKind, ItemKind>?

    // MARK: Subject
    
    var refreshButtonTapSubject = PassthroughSubject<Void, Never>()
    var collectionViewSelectSubject = PassthroughSubject<Int, Never>()
    var tokenUpdateSubject = PassthroughSubject<String, Never>()
    
    // MARK: - UI
    private var homeView: HomeView?
    
    // MARK: Init
    
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
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureDataSource()
        bind()

        updateToken()
    }
    
    override func loadView() {
        super.loadView()
        
        let view = HomeView(frame: self.view.frame)
        self.view = view
        self.homeView = view
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

// MARK: - Configure
private extension HomeViewController {
    
    func configure() {
        homeView?.collectionView.delegate = self
    }
    
    func bind() {
        guard let viewModel = viewModel,
              let homeView = homeView else { return }
        
        let output = viewModel.transform(
            input: HomeViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                didTappedRefreshButton: refreshButtonTapSubject.eraseToAnyPublisher(),
                didSelectedMateCollectionCell: collectionViewSelectSubject.eraseToAnyPublisher(),
                didTappedHeartButton: homeView.numOfHeartButton.tapPublisher().eraseToAnyPublisher(),
                tokenUpdateEvent: tokenUpdateSubject.eraseToAnyPublisher()
            )
        )

        output.didRefreshedPreviewList
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self, homeView] previewViewModelList in
                if previewViewModelList.count == 0 {
                    homeView.collectionView.isHidden = true
                    homeView.hiddenLabel.isHidden = false
                } else {
                    homeView.collectionView.isHidden = false
                    homeView.hiddenLabel.isHidden = true
                }

                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append(previewViewModelList.enumerated().map { index, value in
                    return ItemKind.main(HomePreviewViewModelWrapper(index: index, previewViewModel: value))
                })
                self?.dataSource?.apply(snapshot, to: .main) {
                    homeView.collectionView.isScrollEnabled = true
                    homeView.collectionView.allowsSelection = true
                }
            }
            .store(in: &cancellables)
        
        output.didUpdatedHeartInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak homeView] heartInfo in
                guard let heart = heartInfo.heart else { return }
                homeView?.numOfHeartButton.setTitle("\(heart)", for: .normal)
            }
            .store(in: &cancellables)
        
        output.didStartRefreshing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.fakeSnapshot()
            }
            .store(in: &cancellables)
        
        output.lessHeart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showPopUp(title: "하트 부족",
                                message: "하트가 부족합니다. 충전하러 갈까요?",
                                leftActionTitle: "취소",
                                rightActionTitle: "충전하기",
                                rightActionCompletion: {
                    self?.viewModel?.actions?.showHeartShopFlow?()
                })
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView DataSource

private extension HomeViewController {

    func configureDataSource() {
        
        guard let homeView = homeView else { return }

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
                self?.refreshButtonTapSubject.send(())
            }
        }
        
        // MARK: DataSource Configuration
        self.dataSource = UICollectionViewDiffableDataSource<SectionKind, ItemKind>(collectionView: homeView.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
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
}

// MARK: CollectionView Skeleton Diffable Snapshot
private extension HomeViewController {
    
    func fakeSnapshot() {
        guard let homeView = homeView else { return }
        
        let estimatedNumberOfRows = Int(ceil(self.view.frame.height / (self.view.frame.width - 20)))
        var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
        var targetSource = (0..<estimatedNumberOfRows).map {
            return HomePreviewViewModelWrapper(index: $0)
        }
        snapshot.append(targetSource.map { return .main($0) })

        dataSource?.apply(snapshot, to: .main) { [weak homeView] in
            homeView?.collectionView.isScrollEnabled = false
            homeView?.collectionView.allowsSelection = false
        }
        homeView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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


// MARK: - Read UserDefault

private extension HomeViewController {
    
    func updateToken() {
        print("homeVC update token")
        UserDefaults.standard
            .publisher(for: \.token)
            .compactMap { $0 }
            .sink { [weak self] token in
                self?.tokenUpdateSubject.send(token)
            }
            .store(in: &cancellables)
    }
}
