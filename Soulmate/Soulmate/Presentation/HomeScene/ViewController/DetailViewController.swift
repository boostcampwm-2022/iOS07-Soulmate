//
//  DetailViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import Combine

import SnapKit

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let currentImagePageSubject = PassthroughSubject<Int, Never>()
    private let totalImagePageSubject = PassthroughSubject<Int, Never>()
    
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

    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.bounces = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        self.view.addSubview(collection)
        return collection
    }()
    
    private lazy var applyButton: GradientButton = {
        let button = GradientButton(title: "대화친구 신청하기")
        self.view.addSubview(button)
        return button
    }()
    
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
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureDataSource()
        bind()
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
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: DetailViewModel.Input(
                didTappedMateRegistrationButton: applyButton.tapPublisher()
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
            .sink {
                print("하트부족!")
            }
            .store(in: &cancellables)
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(applyButton.snp.top)
        }
        
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.view.snp.bottom).inset(46)
            $0.height.equalTo(54)
        }
    }
    
    func configureDataSource() {
        
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
        
        self.dataSource = UICollectionViewDiffableDataSource<SectionKind, ItemKind>(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
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

extension DetailViewController {

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.photoLayoutSection()
            case 1: return self.profileLayoutSection()
            case 2: return self.greetingLayoutSection()
            case 3: return self.basicInfoLayoutSection()
            default: return self.basicInfoLayoutSection()
            }
        }
    }
    
    private func photoLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: PhotoFooterView.footerKind,
            alignment: .bottom
        )
    
        section.boundarySupplementaryItems = [footer]
        section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ -> Void in
            guard let width = self?.view.bounds.width else { return }
            let page = round(offset.x / width)
            self?.currentImagePageSubject.send(Int(page))
        }
        return section
    }
    
    private func profileLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func greetingLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func basicInfoLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
