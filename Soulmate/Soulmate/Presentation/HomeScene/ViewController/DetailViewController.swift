//
//  DetailViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

import SnapKit

final class DetailViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .borderPurple
        collection.bounces = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        self.view.addSubview(collection)
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collection.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collection.register(GreetingCell.self, forCellWithReuseIdentifier: "GreetingCell")
        collection.register(BasicInfoCell.self, forCellWithReuseIdentifier: "BasicInfoCell")
        return collection
    }()
    
    
    private lazy var applyButton: GradientButton = {
        let button = GradientButton(title: "대화친구 신청하기")
        self.view.addSubview(button)
        return button
    }()
    
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
            return 5
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
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProfileCell",
                for: indexPath) as? ProfileCell else { return ProfileCell() }
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "GreetingCell",
                for: indexPath) as? GreetingCell else { return GreetingCell() }
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BasicInfoCell",
                for: indexPath) as? BasicInfoCell else { return BasicInfoCell() }
            return cell
            
        default:
            fatalError("indexPath.section")
        }

    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.firstLayoutSection()
            case 1: return self.secondLayoutSection()
            case 2: return self.thirdLayoutSection()
            case 3: return self.forthLayoutSection()
            default: return self.forthLayoutSection()
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 5
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalWidth(0.95))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func thirdLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func forthLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
}


// MARK: - 사진 셀
final class PhotoCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.image = UIImage(named: "emoji")
        contentView.addSubview(photo)
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(imageView.snp.height)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}


// MARK: - 프로필 셀
final class ProfileCell: UICollectionViewCell {
    private lazy var partnerSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        contentView.addSubview(view)
        return view
    }()

    private lazy var partnerName: UILabel = {
        let label = UILabel()
        label.text = "초록잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapColor")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        partnerSubView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
        label.text = "3 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.labelGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        partnerSubView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        
        partnerName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerAge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(84)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerMapImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.left.equalToSuperview().inset(22.48)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        partnerDistance.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        partnerSubView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: - 인사말 셀
final class GreetingCell: UICollectionViewCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "인사말"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var greetingMessage: UILabel = {
        let message = UILabel()
        message.text = "솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋 솔직한 사람이 좋아요😋"
        message.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        message.textColor = UIColor.labelGrey
        message.numberOfLines = 0
        message.lineBreakStrategy = .hangulWordPriority
        contentView.addSubview(message)
        return message
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(42)
            $0.height.equalTo(22)
        }
        
        greetingMessage.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(12)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalToSuperview().inset(40)
        }
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: - 기본정보 셀
final class BasicInfoCell: UICollectionViewCell {
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkLabel: UILabel = {
        let label = UILabel()
        label.text = "음주"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeLabel: UILabel = {
        let label = UILabel()
        label.text = "흡연"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.labelGrey
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var heightInput: UILabel = {
        let label = UILabel()
        label.text = "161cm"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiInput: UILabel = {
        let label = UILabel()
        label.text = "ISFP"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkInput: UILabel = {
        let label = UILabel()
        label.text = "가끔 마심"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeInput: UILabel = {
        let label = UILabel()
        label.text = "비흡연"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        heightLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(33)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(heightLabel.snp.bottom).offset(22)
        }
        
        drinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(mbtiLabel.snp.bottom).offset(22)
        }
        
        smokeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(drinkLabel.snp.bottom).offset(22)
        }
        
        heightInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalToSuperview().offset(32)
        }
        
        mbtiInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(heightInput.snp.bottom).offset(20)
        }
        
        drinkInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(mbtiInput.snp.bottom).offset(20)
        }
        
        smokeInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(drinkInput.snp.bottom).offset(20)
        }
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
