//
//  HomeViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    private var viewModel: HomeViewModel?
    
    // MARK: - UI
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 18)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var heart: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.frame = CGRect(x: 0, y: 0, width: 17.07, height: 14.06)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()

    
    private lazy var numOfHeartLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        label.textColor = UIColor.labelDarkGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        self.view.addSubview(label)
        return label
    }()
    
    // MARK: - 컬렉션뷰
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width - 40, height: view.frame.size.width - 40)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PartnerCell.self, forCellWithReuseIdentifier: "PartnerCell")
        cv.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        cv.showsVerticalScrollIndicator = false
        cv.bounces = true
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        
        self.view.addSubview(cv)
        return cv
    }()
    
    // MARK: - 다시 추천 버튼
    private lazy var recommendAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.frame = CGRect(x: 0, y: 0, width: 310, height: 22)
        button.setTitle("한번 더 추천받기", for: .normal)
        button.setTitleColor(UIColor.messagePurple, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.borderPurple?.cgColor
        self.view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: HomeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
    }
}

// MARK: - View Generators

private extension HomeViewController {
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: HomeViewModel.Input())
        output.didRefreshedImageList
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &bag)
        
        output.didRefreshedPreviewList
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &bag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureLayout() {
        logo.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.snp.top).offset(64)
            $0.width.equalTo(140)
            $0.height.equalTo(18)
        }
        
        heart.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45.46)
            $0.top.equalTo(view.snp.top).offset(65.97)
            $0.width.equalTo(17.07)
            $0.height.equalTo(14.06)
        }
        
        numOfHeartLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.snp.top).offset(64)
        }
        
        recommendAgainButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.bottom.equalTo(recommendAgainButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 추천 인원수 전달하기
        guard let viewModel = viewModel else { return 0 }
        return viewModel.recommendedMatePreviewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as? PartnerCell,
              let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        
        cell.fill(
            with: viewModel.recommendedMatePreviewList[indexPath.row],
            imageData: viewModel.recommendedMatePreviewList.count == viewModel.recommendedMateImageList.count
            ? viewModel.recommendedMateImageList[indexPath.row] : nil
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let vc = viewModel?.coordinator?.showDetailVC() else { return }
//        self.present(vc, animated: true)
        guard let viewModel = viewModel else { return }
        viewModel.mateSelected(index: indexPath.row)
    }
    
}
