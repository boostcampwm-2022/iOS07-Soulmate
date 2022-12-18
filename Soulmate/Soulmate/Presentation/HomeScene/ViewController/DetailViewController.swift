//
//  DetailViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: DetailViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var detailView: DetailView?
    
    // MARK: - Subject
    
    private let totalImagePageSubject = PassthroughSubject<Int, Never>()
    private let currentImagePageSubject = PassthroughSubject<Int, Never>()
    private let sendMateRequestSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Diffable DataSource
    
    enum SectionKind: Int, CaseIterable {
        case photo
        case profile
        case greeting
        case basicInfo
    }
    
    enum ItemKind: Hashable {
        case photo(String)
        case profile(DetailPreviewViewModel)
        case greeting(String)
        case basicInfo(DetailBasicInfoViewModel)
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionKind, ItemKind>?
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: DetailViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        let view = DetailView(frame: self.view.frame)
        self.detailView = view
        self.view = view
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

// MARK: - configure

private extension DetailViewController {
    
    func configure() {
        detailView?.applyButton.configureButtonHandler(handler: sendMateRequestEvent)
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: DetailViewModel.Input(
                didTappedMateRegistrationButton: sendMateRequestSubject.eraseToAnyPublisher()
            )
        )
        
        output.didFetchedImageKeyList
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageKeyList in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append(imageKeyList.map { ItemKind.photo($0) })
                self?.dataSource?.apply(snapshot, to: .photo)
                self?.totalImagePageSubject.send(imageKeyList.count)
            }
            .store(in: &cancellables)
        
        output.didFetchedPreview
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] previewViewModel in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append([ItemKind.profile(previewViewModel)])
                self?.dataSource?.apply(snapshot, to: .profile)
            }
            .store(in: &cancellables)
        
        output.didFetchedGreeting
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] greeting in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append([ItemKind.greeting(greeting)])
                self?.dataSource?.apply(snapshot, to: .greeting)
            }
            .store(in: &cancellables)
        
        output.didFetchedBasicInfo
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] infoViewModel in
                var snapshot = NSDiffableDataSourceSectionSnapshot<ItemKind>()
                snapshot.append([ItemKind.basicInfo(infoViewModel)])
                self?.dataSource?.apply(snapshot, to: .basicInfo)
            }
            .store(in: &cancellables)
        
        output.lessHeart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showPopUp(
                    title: "하트 부족",
                    message: "하트가 부족합니다. 충전하러 갈까요?",
                    leftActionTitle: "취소",
                    rightActionTitle: "충전하기",
                    rightActionCompletion: {
                        self?.dismiss(animated: true)
                        self?.viewModel?.actions?.showHeartShopFlow?()
                    }
                )
            }
            .store(in: &cancellables)
        
        output.didFinishedRequest
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        detailView?.$currentImagePage
            .sink { [weak self] page in
                self?.currentImagePageSubject.send(page)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions

private extension DetailViewController {
    func sendMateRequestEvent() {
        sendMateRequestSubject.send(())
    }
}

// MARK: - Configure CollectionView

private extension DetailViewController {
    func configureDataSource() {
        guard let detailView = detailView else { return }
        
        // MARK: Cell Registration
        
        let photoCellRegistration = UICollectionView.CellRegistration<PhotoCell, String> { (cell, indexPath, identifier) in
            Task { [weak self] in
                guard let data = try await self?.viewModel?.fetchImage(key: identifier),
                      let uiImage = UIImage(data: data) else { return }
                
                await MainActor.run {
                    cell.fill(image: uiImage)
                }
            }
        }
        
        let profileCellRegistration = UICollectionView.CellRegistration<ProfileCell, DetailPreviewViewModel> { (cell, indexPath, identifier) in
            cell.fill(previewViewModel: identifier)
        }
        
        let greetingCellRegistration = UICollectionView.CellRegistration<GreetingCell, String> { (cell, indexPath, identifier) in
            cell.fill(message: identifier)
        }
        
        let infoCellRegistration = UICollectionView.CellRegistration<BasicInfoCell, DetailBasicInfoViewModel> { (cell, indexPath, identifier) in
            cell.fill(infoViewModel: identifier)
        }
        
        let footerViewRegistration = UICollectionView.SupplementaryRegistration
        <PhotoFooterView>(elementKind: PhotoFooterView.footerKind) { [weak self] supplementaryView, string, indexPath in
            guard let currentPage = self?.currentImagePageSubject,
                  let totalPage = self?.totalImagePageSubject else { return }
            supplementaryView.subscribeTo(totalPage: totalPage.eraseToAnyPublisher())
            supplementaryView.subscribeTo(currentPage: currentPage.eraseToAnyPublisher())
        }
        
        // MARK: DataSource Configuration
        
        self.dataSource = UICollectionViewDiffableDataSource<SectionKind, ItemKind>(collectionView: detailView.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .photo(let imageKey):
                return collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: imageKey)
            case .profile(let previewViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: previewViewModel)
            case .greeting(let greetingMessage):
                return collectionView.dequeueConfiguredReusableCell(using: greetingCellRegistration, for: indexPath, item: greetingMessage)
            case .basicInfo(let infoViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: infoViewModel)
            }
        }
        
        self.dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerViewRegistration, for: indexPath)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, ItemKind>()
        snapshot.appendSections(SectionKind.allCases)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
