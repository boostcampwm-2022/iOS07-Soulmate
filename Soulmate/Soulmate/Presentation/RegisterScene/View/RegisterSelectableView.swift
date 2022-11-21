//
//  RegisterGenderViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

class RegisterSelectableView: UIView {
        
    var bag = Set<AnyCancellable>()
    @Published var selectedIndex: Int?
    
    var selectableType: SelectableType.Type?
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        self.addSubview(headerView)
        return headerView
    }()
    
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(selectableType: SelectableType.Type) {
        self.init(frame: .zero)
        
        self.selectableType = selectableType
        
        configureView()
        configureLayout()
        
        bind()
    }
}

// MARK: - View Generators

private extension RegisterSelectableView {
    
    func bind() { // 여기선 저쪽에 있는 뷰모델에 바인딩을 해야한다... 어케 접근할까..? 아니면 그냥 이 뷰 자체에서 바인딩을 할까??
        
    }

    func configureView() {
        self.backgroundColor = .systemBackground
        collectionView.register(SelectableCell.self, forCellWithReuseIdentifier: "SelectableCell")
        
        guard let selectableType = selectableType else { return }
        registerHeaderStackView.setMessage(
            guideText: selectableType.guideText,
            descriptionText: selectableType.descriptionText
        )
    }
    
    func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(registerHeaderStackView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-84)
        }
    }
    
    
}

extension RegisterSelectableView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selectableType = selectableType else { return 0 }
        return selectableType.cases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let selectableType = selectableType,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectableCell", for: indexPath) as? SelectableCell else { return UICollectionViewCell() }
        
        cell.fill(with: selectableType.cases[indexPath.row].value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedIndex = nil
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            selectedIndex = indexPath.row
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let cellWidth = self.frame.width - 20*2
        let cellHeight = CGFloat(72)
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
}

protocol SelectableType {
    static var cases: [SelectableType] { get }
    static var guideText: String { get }
    static var descriptionText: String? { get }
    var value: String { get }
}

enum GenderType: String, CaseIterable, SelectableType {
    case male = "남성"
    case female = "여성"
    
    static var cases: [SelectableType] {
        return Self.allCases
    }
    
    static var guideText: String = "처음 오셨네요,\n성별이 어떻게 되시나요?"
    static var descriptionText: String? = "가입 후 성별은 변경이 불가능합니다."
    
    var value: String {
        return self.rawValue
    }
}

enum SmokingType: String, CaseIterable, SelectableType {
    case `none` = "비흡연"
    case sometimes = "가끔 흡연"
    case often = "흡연"
    
    static var cases: [SelectableType] {
        return Self.allCases
    }
    
    static var guideText: String = "흡연 여부를 알려주세요"
    static var descriptionText: String? = nil
    
    var value: String {
        return self.rawValue
    }
}

enum DrinkingType: String, CaseIterable, SelectableType {
    case `none` = "전혀 안함"
    case rarely = "피할 수 없을 때만"
    case sometimes = "가끔"
    case often = "자주"
    
    static var cases: [SelectableType] {
        return Self.allCases
    }
    
    static var guideText: String = "음주 여부를 알려주세요"
    static var descriptionText: String? = nil
    
    var value: String {
        return self.rawValue
    }
}
