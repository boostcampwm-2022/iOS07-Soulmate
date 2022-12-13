//
//  ModificationViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import FirebaseAuth
import Combine
import PhotosUI

enum ModificationSectionKind: Int, CaseIterable {

    case profileImage = 0
    case profileInfo = 1

    var headerTitle: String {
        switch self {
        case .profileImage:
            return "프로필 사진"
        case .profileInfo:
            return "개인 정보"
        }
    }
}

enum ModificationItemKind: Hashable {
    case profileImage(ModificationImageViewModel)
    case profileInfo(ModificationInfoViewModel)
}

class ModificationViewController: UIViewController {
    
    var cancelables = Set<AnyCancellable>()
    var viewModel: ModificationViewModel?
    
    var selectedPhotoIndex: Int?
    
    static let headerElementKind = "header-element-kind"

    private var dataSource: UICollectionViewDiffableDataSource<ModificationSectionKind, ModificationItemKind>!
    private var collectionView: UICollectionView!
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        return button
    }()


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ModificationViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureView()
        self.view.backgroundColor = .systemBackground
        
        bind()
    }
    
    func configureView() {
        navigationItem.setRightBarButton(UIBarButtonItem(customView: saveButton), animated: true)
        navigationItem.title = "내 정보 수정"
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: ModificationViewModel.Input(
                didTappedSaveButton: saveButton.tapPublisher()
            )
        )
        
        output.didChangedDetailInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ModificationItemKind>()
                sectionSnapshot.append([
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "성별", value: value.gender?.rawValue ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "닉네임", value: value.nickName ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "생년월일", value: value.birthDay?.yyyyMMdd() ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "키", value: String(value.height ?? 0))),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "MBTI", value: value.mbti?.toString() ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "흡연여부", value: value.smokingType?.rawValue ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "음주여부", value: value.drinkingType?.rawValue ?? "")),
                    ModificationItemKind.profileInfo(ModificationInfoViewModel(key: "소개", value: value.aboutMe ?? ""))
                ])
                self?.dataSource.apply(sectionSnapshot, to: .profileInfo)
            }
            .store(in: &cancelables)
        
        output.didChangedImageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ModificationItemKind>()
                let snapshotTarget = value.enumerated().map { (index, value) in
                    return ModificationItemKind.profileImage(ModificationImageViewModel(index: index, imageData: value ?? Data()))
                }
                sectionSnapshot.append(snapshotTarget)
                self?.dataSource.apply(sectionSnapshot, to: .profileImage)
            }
            .store(in: &cancelables)
        
        // TODO: 채팅이미지 넣는부분 개선하기
        output.didChangedImageData
            .compactMap { $0[0] }
            .sink { [weak self] value in
                guard let image = UIImage(data: value) else { return }
                
                let ratio = image.size.width / 50
                let ratioHeight = image.size.height * ratio
                let newImage = UIImage.resizeImage(image: image, targetSize: CGSize(width: 50, height: ratioHeight))!
            
                guard let data = newImage.jpegData(compressionQuality: 1) else { return }
                self?.viewModel?.userChatImageData = data
            }
            .store(in: &cancelables)
        
        output.didUploadAllInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel?.finishModification()
            }
            .store(in: &cancelables)
    }
    
}

extension ModificationViewController {

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
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(45))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: Self.headerElementKind,
            alignment: .top
        )

        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return section
    }

    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(62))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(45))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: Self.headerElementKind,
            alignment: .top
        )

        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            guard let self,
                  let sectionKind = ModificationSectionKind(rawValue: sectionIndex) else { return nil }

            // MARK: Item Layout

            switch sectionKind {
            case .profileImage:
                return self.createImageSection()
            case .profileInfo:
                return self.createInfoSection()
            }
        }
    }

    private func configureDataSource() {

        // MARK: Cell Registration

        let imageCellRegistration = UICollectionView.CellRegistration<AddPhotoCell, ModificationImageViewModel> { (cell, indexPath, identifier) in
            cell.fill(with: identifier.imageData)
        }

        let infoCellRegistration = UICollectionView.CellRegistration<ModificationInfoCell, ModificationInfoViewModel> { (cell, indexPath, identifier) in
            cell.fill(with: identifier)
        }

        // MARK: Header Registration
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <ModificationTitleSupplementaryView>(elementKind: ModificationViewController.headerElementKind) {
            (supplementaryView, string, indexPath) in
            let sectionKind = ModificationSectionKind(rawValue: indexPath.section)!
            supplementaryView.label.text = sectionKind.headerTitle
        }
        
        // MARK: DataSoucre Cell Provider

        dataSource = UICollectionViewDiffableDataSource<ModificationSectionKind, ModificationItemKind>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .profileImage(let imageViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: imageViewModel)
            case .profileInfo(let infoViewModel):
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: infoViewModel)
            }
        }
        
        // MARK: DataSource Header Provider
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }

        // 초기 데이터 셋팅(섹션 셋팅)
        var snapshot = NSDiffableDataSourceSnapshot<ModificationSectionKind, ModificationItemKind>()
        snapshot.appendSections(ModificationSectionKind.allCases)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ModificationViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        configureDataSource()
    }
}

extension ModificationViewController {
    func presentGenderPopUp() {
        let registerSelectableView = RegisterSelectableView<GenderType>()
        registerSelectableView.configureHistory(selectableValue: viewModel?.userDetailInfo?.gender)
        
        let vc = ModificationPopUpViewController(containerView: registerSelectableView)
        registerSelectableView.selectablePublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.gender = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentNickNamePopUp() {
        let registerNickNameView = RegisterNickNameView()
        registerNickNameView.configureHistory(nickName: viewModel?.userDetailInfo?.nickName)

        let vc = ModificationPopUpViewController(containerView: registerNickNameView)
        registerNickNameView.nickNamePublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.nickName = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentBirthPopUp() {
        let registerBirthView = RegisterBirthView()
        registerBirthView.configureHistory(birth: viewModel?.userDetailInfo?.birthDay)
        
        let vc = ModificationPopUpViewController(containerView: registerBirthView)
        registerBirthView.birthPublisher()
            .sink { value in
                self.viewModel?.userDetailInfo?.birthDay = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentHeightPopUp() {
        let registerHeightView = RegisterHeightView()
        registerHeightView.configureHistory(height: viewModel?.userDetailInfo?.height)

        let vc = ModificationPopUpViewController(containerView: registerHeightView)
        registerHeightView.heightPublisher()
            .sink { value in
                self.viewModel?.userDetailInfo?.height = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentMbtiPopUp() {
        let registerMbtiView = RegisterMbtiView()
        registerMbtiView.configureHistory(mbti: viewModel?.userDetailInfo?.mbti)
        
        let vc = ModificationPopUpViewController(containerView: registerMbtiView)
        registerMbtiView.mbtiPublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.mbti = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentSmokingPopUp() {
        let registerSelectableView = RegisterSelectableView<SmokingType>()
        registerSelectableView.configureHistory(selectableValue: viewModel?.userDetailInfo?.smokingType)

        let vc = ModificationPopUpViewController(containerView: registerSelectableView)
        registerSelectableView.selectablePublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.smokingType = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentDrinkingPopUp() {
        let registerSelectableView = RegisterSelectableView<DrinkingType>()
        registerSelectableView.configureHistory(selectableValue: viewModel?.userDetailInfo?.drinkingType)
        
        let vc = ModificationPopUpViewController(containerView: registerSelectableView)
        registerSelectableView.selectablePublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.drinkingType = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
    
    func presentIntroductionPopUp() {
        let registerIntroductionView = RegisterIntroductionView()
        registerIntroductionView.configureHistory(introduction: viewModel?.userDetailInfo?.aboutMe)
        
        let vc = ModificationPopUpViewController(containerView: registerIntroductionView)
        registerIntroductionView.introductionPublisher()
            .sink { value in
                if value == nil {
                    vc.dismissButton.isEnabled = false
                } else {
                    vc.dismissButton.isEnabled = true
                }
                self.viewModel?.userDetailInfo?.aboutMe = value
            }
            .store(in: &cancelables)
        present(vc, animated: false, completion: nil)
    }
}

extension ModificationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            selectedPhotoIndex = indexPath.row
            presentPhotoPicker()
        case 1:
            switch indexPath.row {
            case 0:
                presentGenderPopUp()
            case 1:
                presentNickNamePopUp()
            case 2:
                presentBirthPopUp()
            case 3:
                presentHeightPopUp()
            case 4:
                presentMbtiPopUp()
            case 5:
                presentSmokingPopUp()
            case 6:
                presentDrinkingPopUp()
            case 7:
                presentIntroductionPopUp()
            default:
                return
            }
        default:
            return
        }
    }
}

extension ModificationViewController {
    func presentPhotoPicker() {
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = 1
        phPickerConfiguration.filter = .images
        phPickerConfiguration.preferredAssetRepresentationMode = .current

        let phPicker = PHPickerViewController(configuration: phPickerConfiguration)
        phPicker.delegate = self
        self.present(phPicker, animated: true)
    }
}

extension ModificationViewController: PHPickerViewControllerDelegate { //PHPicker 델리게이트
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.first?.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] (data, error) in
            guard let data = data,
                  let selectedIndex = self?.selectedPhotoIndex,
                  let image = UIImage(data: data) else { return }
            
            let ratio = image.size.width / 390
            let ratioHeight = image.size.height * ratio
            
            let newImage = UIImage.resizeImage(image: image, targetSize: CGSize(width: 390, height: ratioHeight))!
            
            
            guard let data = newImage.jpegData(compressionQuality: 0.9) else { return }
            
            self?.viewModel?.userDetailImageData[selectedIndex] = data
            self?.selectedPhotoIndex = nil
        }
        
    }
    
    
}


// MARK: - 미리보기
#if DEBUG
import SwiftUI
struct ModificationViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        ModificationViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                ModificationViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
