//
//  PhotoViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/17.
//

import UIKit
import Combine
import SnapKit
import PhotosUI

protocol RegisterPhotoViewDelegate: AnyObject {
    func presentPhotoPicker(_ registerPhotoView: RegisterPhotoView)
}

enum RegisterPhotoViewSectionKind: Int, CaseIterable {
    case main = 0
}

enum RegisterPhotoViewItemKind: Hashable {
    case main(RegisterImageItemViewModel)
}

final class RegisterPhotoView: UIView {
    
    var cancellable = Set<AnyCancellable>()
    
    var pickingItem: Int?
    @Published var imageList: [Data?] = [nil, nil, nil, nil, nil]
    
    weak var delegate: RegisterPhotoViewDelegate?
            
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "회원님의 사진을\n업로드해주세요.",
            descriptionText: "얼굴이 잘 나온 사진을 업로드해주세요."
        )
        self.addSubview(headerView)
        return headerView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<RegisterPhotoViewSectionKind, RegisterPhotoViewItemKind>!
    lazy var collectionView: UICollectionView = {

        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        cv.delegate = self
        
        self.addSubview(cv)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        configureView()
        configureLayout()
        
        configureDataSource()
        bind()
    }
    
    func imageListPublisher() -> AnyPublisher<[Data?], Never> {
        return $imageList
            .eraseToAnyPublisher()
    }

}

private extension RegisterPhotoView {
    
    private func bind() {
        $imageList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.snapshotDataSoucre()
            }
            .store(in: &cancellable)
    }

    private func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(184)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(208.5)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }

    }
}


extension RegisterPhotoView {

    // MARK: CollectionView compositional layout

    private func createImageSection() -> NSCollectionLayoutSection {
        let topItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
        let topItem = NSCollectionLayoutItem(layoutSize: topItemSize)
        topItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        
        let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)
        bottomItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let topGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1/2)),
            subitem: topItem, count: 2)
        
        let bottomGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1/3)),
            subitem: topItem, count: 3)

        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1/3 + 1/2)),
            subitems: [topGroup, bottomGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return section
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionKind = RegisterPhotoViewSectionKind(rawValue: sectionIndex) else { return nil }

            // MARK: Item Layout

            switch sectionKind {
            case .main:
                return self?.createImageSection()
            }
        }
    }

    private func configureDataSource() {

        // MARK: Cell Registration

        let imageCellRegistration = UICollectionView.CellRegistration<AddPhotoCell, RegisterImageItemViewModel> { (cell, indexPath, identifier) in
            cell.fill(with: identifier.data)
        }
        
        // MARK: DataSoucre Cell Provider

        dataSource = UICollectionViewDiffableDataSource<RegisterPhotoViewSectionKind, RegisterPhotoViewItemKind>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case .main(let imageViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: imageViewModel)
            }
        }
        snapshotDataSoucre()
    }
    
    func snapshotDataSoucre() {
        var snapshot = NSDiffableDataSourceSnapshot<RegisterPhotoViewSectionKind, RegisterPhotoViewItemKind>()
        snapshot.appendSections(RegisterPhotoViewSectionKind.allCases)
        let targetSource = imageList.enumerated().map { (index, value) in
            return RegisterPhotoViewItemKind.main(RegisterImageItemViewModel(index: index, data: value))
        }
        snapshot.appendItems(targetSource, toSection: .main)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension RegisterPhotoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickingItem = indexPath.row
        delegate?.presentPhotoPicker(self)
    }
}
