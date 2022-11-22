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

final class RegisterPhotoView: UIView {
    
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
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AddPhotoCell.self, forCellWithReuseIdentifier: "AddPhotoCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        
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
        bind()
    }
    
    func imageListPublisher() -> AnyPublisher<[Data?], Never> {
        return $imageList.eraseToAnyPublisher()
    }

}

private extension RegisterPhotoView {
    private func bind() {

    }
    
    private func configureView() {
        self.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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

extension RegisterPhotoView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath) as? AddPhotoCell else { return UICollectionViewCell() }
        cell.fill(with: imageList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        
        if indexPath.item == 0 || indexPath.item == 1 {
            width = 171.5
            height = 171.5
            collectionView.contentInset = centerItemsInCollectionView(cellWidth: width, numberOfItems: 2, spaceBetweenCell: 10, collectionView: collectionView)
        } else {
            width = 112
            height = 112
            collectionView.contentInset = centerItemsInCollectionView(cellWidth: width, numberOfItems: 3, spaceBetweenCell: 10, collectionView: collectionView)
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickingItem = indexPath.row
        delegate?.presentPhotoPicker(self)
    }
    
    private func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

//extension RegisterPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//
//        //dismiss(animated: true, completion: nil)
//    }
//}




//#if DEBUG
//import SwiftUI
//struct PhotoViewControllerRepresentable: UIViewControllerRepresentable {
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        // leave this empty
//    }
//    @available(iOS 13.0.0, *)
//    func makeUIViewController(context: Context) -> some UIViewController {
//        PhotoViewController()
//    }
//    @available(iOS 13.0, *)
//    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
//        static var previews: some View {
//            Group {
//                PhotoViewControllerRepresentable()
//                    .ignoresSafeArea()
//                    .previewDisplayName("Preview")
//                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
//            }
//        }
//    }
//} #endif
