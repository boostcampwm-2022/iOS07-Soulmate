//
//  RegisterGenderViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

class RegisterSelectableView<T: SelectableType>: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    var bag = Set<AnyCancellable>()
    @Published var selectedIndex: Int?
        
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
    
    convenience init() {
        self.init(frame: .zero)
                
        configureView()
        configureLayout()
        
    }
    
    func configureHistory(selectableValue: T?) {
        if let index = selectableValue?.index {
            collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .top)
            selectedIndex = index
        }
    }
    
    func selectablePublisher() -> AnyPublisher<T?, Never> {
        return $selectedIndex.map { index -> T? in
            guard let index = index,
                  let value = T.cases[index] as? T else {
                return nil
            }
            return value
        }
        .eraseToAnyPublisher()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return T.cases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectableCell", for: indexPath) as? SelectableCell else { return UICollectionViewCell() }
        
        cell.fill(with: T.cases[indexPath.row].value)
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

// MARK: - View Generators

private extension RegisterSelectableView {

    func configureView() {
        self.backgroundColor = .systemBackground
        collectionView.register(SelectableCell.self, forCellWithReuseIdentifier: "SelectableCell")
        
        registerHeaderStackView.setMessage(
            guideText: T.guideText,
            descriptionText: T.descriptionText
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

protocol SelectableType {
    static var cases: [SelectableType] { get }
    static var guideText: String { get }
    static var descriptionText: String? { get }
    var value: String { get }
    var index: Int? { get }
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
    
    var index: Int? {
        return Self.allCases.firstIndex(of: self)
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
    
    var index: Int? {
        return Self.allCases.firstIndex(of: self)
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
    
    var index: Int? {
        return Self.allCases.firstIndex(of: self)
    }
}
