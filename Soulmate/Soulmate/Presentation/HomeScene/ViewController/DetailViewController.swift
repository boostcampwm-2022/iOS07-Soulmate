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
    private let pagingInfoSubject = PassthroughSubject<Int, Never>()
    private let photosPublisher = PassthroughSubject<[String], Never>()
    private let nicknamePublisher = PassthroughSubject<String, Never>()
    private let agePublisher = PassthroughSubject<Date, Never>()
    private let distancePublisher = PassthroughSubject<Int, Never>()
    private let greetingMessagePublisher = PassthroughSubject<String, Never>()
    private let heightPublisher = PassthroughSubject<Int, Never>()
    private let mbtiPublisher = PassthroughSubject<Mbti, Never>()
    private let drinkingPublisher = PassthroughSubject<DrinkingType, Never>()
    private let smokingPublisher = PassthroughSubject<SmokingType, Never>()

    private var viewModel: DetailViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
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
        
        bind()
    }
}

// MARK: - configure
private extension DetailViewController {
    private func bind() {
        let _ = viewModel?.transform(input: DetailViewModel.Input(
            setPhotos: photosPublisher.eraseToAnyPublisher(),
            setNickname: nicknamePublisher.eraseToAnyPublisher(),
            setAge: agePublisher.eraseToAnyPublisher(),
            setDistance: distancePublisher.eraseToAnyPublisher(),
            setGreetingMessage: greetingMessagePublisher.eraseToAnyPublisher(),
            setHeight: heightPublisher.eraseToAnyPublisher(),
            setMbti: mbtiPublisher.eraseToAnyPublisher(),
            setDrinking: drinkingPublisher.eraseToAnyPublisher(),
            setSmoking: smokingPublisher.eraseToAnyPublisher(),
            didTouchedTalkButton: applyButton.tapPublisher()))
        
        photosPublisher.send(viewModel?.userInfo?.imageList ?? [])
        nicknamePublisher.send(viewModel?.userInfo?.nickName ?? "")
        agePublisher.send(viewModel?.userInfo?.birthDay ?? Date())
        distancePublisher.send(viewModel?.distance ?? 0)
        greetingMessagePublisher.send(viewModel?.userInfo?.aboutMe ?? "")
        heightPublisher.send(viewModel?.userInfo?.height ?? 0)
        mbtiPublisher.send(viewModel?.userInfo?.mbti ?? Mbti(innerType: .i, recognizeType: .n, judgementType: .t, lifeStyleType: .p))
        drinkingPublisher.send(viewModel?.userInfo?.drinkingType ?? DrinkingType.none)
        smokingPublisher.send(viewModel?.userInfo?.smokingType ?? SmokingType.none)
        
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
}
    
// MARK: - 컬렉션 뷰
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel?.photos?.count ?? 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "PhotoCell",
                for: indexPath) as? PhotoCell else { return PhotoCell() }
            cell.loadImage(image: viewModel?.photos?[indexPath.item] ?? "")
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProfileCell",
                for: indexPath) as? ProfileCell else { return ProfileCell() }
            cell.configure(nickName: viewModel?.nickname ?? "", age: viewModel?.age ?? 0, distance: viewModel?.distance ?? 0)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "GreetingCell",
                for: indexPath) as? GreetingCell else { return GreetingCell() }
            cell.configure(message: viewModel?.greetingMessage ?? "[등록된 인사말이 없습니다🥲]")
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BasicInfoCell",
                for: indexPath) as? BasicInfoCell,
                  let height = viewModel?.height,
                  let mbti = viewModel?.mbti,
                  let drink = viewModel?.drinking,
                  let smoke = viewModel?.smoking else { return BasicInfoCell() }
            cell.configure(height: height, mbti: mbti, drink: drink, smoke: smoke)
            return cell
            
        default:
            fatalError("indexPath.section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoFooterView", for: indexPath) as? PhotoFooterView else { return PhotoFooterView() }
        footer.configure(with: collectionView.numberOfItems(inSection: 0))
        footer.subscribeTo(subject: pagingInfoSubject)
        return footer
    }
    
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
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



// MARK: - 미리보기
#if DEBUG
import SwiftUI
struct DetailViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        DetailViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                DetailViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
