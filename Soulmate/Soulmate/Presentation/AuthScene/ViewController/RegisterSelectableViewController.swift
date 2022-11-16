//
//  RegisterGenderViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

class RegisterHeaderStackView: UIStackView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        
        self.addArrangedSubview(label)
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
                
        self.addArrangedSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .equalSpacing
        self.spacing = 12
    }
    
    func setMessage(title: String, subTitle: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.33
        paragraphStyle.alignment = .left
        
        titleLabel.attributedText = NSMutableAttributedString(
            string: title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        guard let subTitle = subTitle else {
            subTitleLabel.isHidden = true
            return
        }
        subTitleLabel.isHidden = false
        subTitleLabel.text = subTitle
    }

}

class RegisterSelectableViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    var handler: (() -> Void)?
    
    @Published var selectableType: (any SelectableType.Type)?
    @Published var selectedIndex: Int?
    
    lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        self.view.addSubview(bar)
        return bar
    }()
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        view.addSubview(headerView)
        return headerView
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let itemWidth = view.frame.width - 20 * 2
        let itemSize = CGSize(width: itemWidth, height: 72)
        layout.itemSize = itemSize
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        view.addSubview(button)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: SelectableType.Type) {
        self.init(nibName: nil, bundle: nil)
        self.selectableType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
    }
    
}

// MARK: - View Generators

private extension RegisterSelectableViewController {
    
    func bind() {
        $selectedIndex
            .map { index in
                return index != nil
            }
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
        
        $selectableType
            .compactMap { $0 }
            .sink { [weak self] type in
                self?.collectionView.reloadData()
                self?.registerHeaderStackView.setMessage(
                    title: type.title,
                    subTitle: type.subTitle
                )
            }
            .store(in: &bag)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        collectionView.register(SelectableCell.self, forCellWithReuseIdentifier: "SelectableCell")
    }
    
    func configureLayout() {
        progressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(6)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(registerHeaderStackView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-33)
        }
    }
}


extension RegisterSelectableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
}

protocol SelectableType {
    static var cases: [SelectableType] { get }
    static var title: String { get }
    static var subTitle: String? { get }
    var value: String { get }
}

enum GenderType: String, CaseIterable, SelectableType {
    case male = "남성"
    case female = "여성"
    
    static var cases: [SelectableType] {
        return Self.allCases
    }
    
    static var title: String = "처음 오셨네요,\n성별이 어떻게 되시나요?"
    static var subTitle: String? = "가입 후 성별은 변경이 불가능합니다."
    
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
    
    static var title: String = "흡연 여부를 알려주세요"
    static var subTitle: String? = nil
    
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
    
    static var title: String = "음주 여부를 알려주세요"
    static var subTitle: String? = nil
    
    var value: String {
        return self.rawValue
    }
}
