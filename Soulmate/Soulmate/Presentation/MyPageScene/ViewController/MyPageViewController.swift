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
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        backBarButtonItem.image = backBarButtonItem.image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0))
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
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
    
    convenience init(viewModel: MyPageViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    
}

private extension MyPageViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: MyPageViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                didTappedMyInfoEditButton: self.contentView.editButton.tapPublisher(),
                didTappedHeartShopButton: self.contentView.remainingHeartButton.tapPublisher(),
                didTappedMenuCell: self.rowSelectSubject.eraseToAnyPublisher()
            )
        )
        
        
        output.didUpdatedImage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.contentView.profileImageView.image = UIImage(data: value)
            }
            .store(in: &cancellables)
        
        output.didUpdatedPreview
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.contentView.profileNameLabel.text = value.name
                self?.contentView.profileAgeLabel.text = "\(value.birth?.toAge() ?? 0)"
            }
            .store(in: &cancellables)
        
        output.didUpdatedHeartInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartInfo in
                guard let heart = heartInfo.heart else { return }
                self?.contentView.remainingHeartLabel.text = "\(heart)개"
            }
            .store(in: &cancellables)
    }
    
}

extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMenuCollectionViewCell.identifier, for: indexPath) as? MyPageMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        cell.symbol.image = UIImage(named: viewModel?.symbols[indexPath.row] ?? "checkOff")
        cell.title.text = viewModel?.titles[indexPath.row]
        if (4...5).contains(indexPath.row) {
            cell.title.textColor = .messagePurple
        }
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
        case 4:
            showPopUp(title: "로그아웃",
                      message: "로그아웃 하시겠습니까?",
                      rightActionCompletion: { [weak self] in
                self?.rowSelectSubject.send(4)
            })
        case 5:
            showPopUp(title: "회원탈퇴",
                      message: "정말로 회원탈퇴하시겠습니까?",
                      rightActionCompletion: { [weak self] in
                self?.rowSelectSubject.send(5)
            })
        default:
            break
        }
    }
}
