//
//  MyPageViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit
import Combine

final class MyPageViewController: UIViewController {
    
    private var viewModel: MyPageViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var rowSelectSubject = PassthroughSubject<Int, Never>()
    
    lazy var contentView = MyPageView()
    
    override func loadView() {
        view = contentView
        self.contentView.collectionView.delegate = self
        self.contentView.collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        // viewModel -> view
        // view -> viewModel
    }
    
    convenience init(viewModel: MyPageViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    
}

private extension MyPageViewController {
    
    func bind() {
        let _ = viewModel?.transform(
            input: MyPageViewModel.Input(
                didTappedMyInfoEditButton: self.contentView.editButton.tapPublisher(),
                didTappedHeartShopButton: self.contentView.remainingHeartButton.tapPublisher(),
                didTappedMenuCell: self.rowSelectSubject.eraseToAnyPublisher()
            )
        )
        
    }
    
}

extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMenuCollectionViewCell.identifier, for: indexPath) as? MyPageMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        cell.symbol.image = UIImage(named: viewModel?.symbols[indexPath.row] ?? "checkOff")
        cell.title.text = viewModel?.titles[indexPath.row]
        cell.trailingDescription.text = viewModel?.subTexts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.collectionView.frame.width, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rowSelectSubject.send(0)
        case 1:
            rowSelectSubject.send(1)
        case 2:
            rowSelectSubject.send(2)
        default:
            break
        }
    }
}
