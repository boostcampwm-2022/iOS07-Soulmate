//
//  HeartShopViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/26.
//

import UIKit
import SnapKit
import Combine

final class HeartShopViewController: UIViewController {
    
    private var viewModel: HeartShopViewModel?
    private var rowSelectSubject = PassthroughSubject<Int, Never>()
    var cancellables = Set<AnyCancellable>()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(cv)
        return cv
    }()
    
    lazy var chargeButton: GradientButton = {
        let button = GradientButton(title: "충전하기")
        self.view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: HeartShopViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "하트 충전"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(HeartShopCell.self, forCellWithReuseIdentifier: HeartShopCell.identifier)
        
        configureLayout()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.actions?.quitHeartShop?()
    }
    
}

private extension HeartShopViewController {
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: HeartShopViewModel.Input(
                didTappedHeartCell: self.rowSelectSubject.eraseToAnyPublisher(),
                didTappedChargeButton: self.chargeButton.tapPublisher()
            )
        )
        
        output.didFinishCharging
            .receive(on: RunLoop.main)
            .sink {
                self.navigationController?.dismiss(animated: true)
            }
            .store(in: &cancellables)
            
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        chargeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.height.equalTo(50)
        }
    }
    
}

extension HeartShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeartShopCell.identifier, for: indexPath) as? HeartShopCell else { return UICollectionViewCell() }
        
        guard let quantities = self.viewModel?.quantities[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.heartQuantity.text = String(quantities) + "개"
        cell.heartPrice.text = self.viewModel?.prices[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            rowSelectSubject.send(1)
        case 1:
            rowSelectSubject.send(2)
        case 2:
            rowSelectSubject.send(3)
        default:
            break
        }
    }
}
