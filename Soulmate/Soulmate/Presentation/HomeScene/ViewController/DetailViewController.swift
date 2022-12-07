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
    private let pagingInfoSubject = PassthroughSubject<Int, Never>()
    
    enum Section: Int, CaseIterable {
        case photo
        case profile
        case greeting
        case basicInfo
    }
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: self.collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        switch Section(rawValue: indexPath.section) {
        case .photo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PhotoCell",
                for: indexPath) as? PhotoCell,
                  let viewModel = self?.viewModel else { preconditionFailure() }

            Task {
                guard let imageKeyList = viewModel.imageKeyList,
                      let data = try await viewModel.fetchImage(key: imageKeyList[indexPath.item]),
                      let uiImage = UIImage(data: data) else { return }

                await MainActor.run {
                    cell.loadImage(image: uiImage)
                }
            }
            return cell
            
        case .profile:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProfileCell",
                for: indexPath) as? ProfileCell else { preconditionFailure() }
            cell.configure(userPreview: self?.viewModel?.preview ?? UserPreview())
            return cell
            
        case .greeting:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "GreetingCell",
                for: indexPath) as? GreetingCell else { preconditionFailure() }
            cell.configure(message: self?.viewModel?.greetingMessage ?? "[등록된 인사말이 없습니다🥲]")
            return cell
            
        case .basicInfo:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BasicInfoCell",
                for: indexPath) as? BasicInfoCell else { preconditionFailure() }
            if let mbti = self?.viewModel?.mbti,
               let height = self?.viewModel?.height,
               let drink = self?.viewModel?.drinking,
               let smoke = self?.viewModel?.smoking {
                cell.configure(
                    height: height,
                    mbti: mbti,
                    drink: drink,
                    smoke: smoke
                )
            }
            return cell
            
        default:
            print("Section error")
            return nil
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.bounces = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        self.view.addSubview(collection)
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collection.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collection.register(GreetingCell.self, forCellWithReuseIdentifier: "GreetingCell")
        collection.register(BasicInfoCell.self, forCellWithReuseIdentifier: "BasicInfoCell")
        collection.register(PhotoFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PhotoFooterView")
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
        configureSnapshot()
        configureFooter()
        bind()
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.configureSnapshot()
            }
            .store(in: &cancellables)
        
        output.didFetchedPreview
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.configureSnapshot()
            }
            .store(in: &cancellables)
        
        output.didFetchedGreeting
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.configureSnapshot()
            }
            .store(in: &cancellables)

        Publishers.CombineLatest4(
            output.didFetchedHeight,
            output.didFetchedMbti,
            output.didFetchedDrinking,
            output.didFetchedSmoking
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.configureSnapshot()
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
    
    func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel?.imageKeyList ?? [], toSection: .photo)
        snapshot.appendItems([viewModel?.preview], toSection: .profile)
        snapshot.appendItems([viewModel?.greetingMessage], toSection: .greeting)
        snapshot.appendItems([viewModel?.basicInfo], toSection: .basicInfo)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureFooter() {
        self.dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionFooter,
                  let subject = self?.pagingInfoSubject,
                  let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "PhotoFooterView",
                    for: indexPath) as? PhotoFooterView,
                  let section = self?.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section] else { return nil }
            
            footer.configure(with: collectionView.numberOfItems(inSection: section.rawValue))
            footer.subscribeTo(subject: subject)
            return footer
        }
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
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    
        section.boundarySupplementaryItems = [footer]
        section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ -> Void in
            guard let self = self else { return }
            let page = round(offset.x / self.view.bounds.width)
            self.pagingInfoSubject.send(Int(page))
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












// MARK: - 컬렉션 뷰

//extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return viewModel?.imageKeyList?.count ?? 0
//        } else {
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "PhotoCell",
//                for: indexPath) as? PhotoCell,
//                  let viewModel = viewModel else { return PhotoCell() }
//
//            Task {
//                guard let imageKeyList = viewModel.imageKeyList,
//                      let data = try await viewModel.fetchImage(key: imageKeyList[indexPath.item]),
//                      let uiImage = UIImage(data: data) else { return }
//
//                await MainActor.run {
//                    cell.loadImage(image: uiImage)
//                }
//            }
//            return cell
//
//        case 1:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "ProfileCell",
//                for: indexPath) as? ProfileCell else { return ProfileCell() }
//            cell.configure(userPreview: viewModel?.preview ?? UserPreview())
//            return cell
//
//        case 2:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "GreetingCell",
//                for: indexPath) as? GreetingCell else { return GreetingCell() }
//            cell.configure(message: viewModel?.greetingMessage ?? "[등록된 인사말이 없습니다🥲]")
//            return cell
//
//        case 3:
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "BasicInfoCell",
//                for: indexPath) as? BasicInfoCell else { return BasicInfoCell() }
//
//            if let mbti = viewModel?.mbti,
//               let height = viewModel?.height,
//               let drink = viewModel?.drinking,
//               let smoke = viewModel?.smoking {
//                cell.configure(
//                    height: height,
//                    mbti: mbti,
//                    drink: drink,
//                    smoke: smoke
//                )
//            }
//
//            return cell
//
//        default:
//            fatalError("indexPath.section")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoFooterView", for: indexPath) as? PhotoFooterView else { return PhotoFooterView() }
//        footer.configure(with: collectionView.numberOfItems(inSection: 0))
//        footer.subscribeTo(subject: pagingInfoSubject)
//        return footer
//    }
//}
