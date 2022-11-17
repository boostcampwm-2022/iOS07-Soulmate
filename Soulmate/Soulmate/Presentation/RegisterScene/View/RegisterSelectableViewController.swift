//
//  RegisterGenderViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/16.
//

import UIKit
import SnapKit
import Combine

class RegisterSelectableViewController: UIViewController {
    
    let transition = ProgressAnimator()
    
    var bag = Set<AnyCancellable>()
    var viewModel: RegisterSelectableViewModel?
    
    @Published var selectedIndex: Int?
    
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar()
        view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.goToNextStep()
        
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
    
    convenience init(viewModel: RegisterSelectableViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
        
        guard let viewModel = viewModel else { return }
        
        let output = viewModel.transform(
            input: RegisterSelectableViewModel.Input(
                didSelectedAtIndex: $selectedIndex.eraseToAnyPublisher(),
                didTappedNextButton: nextButton.tapPublisher()
            )
        )
        
        output.isNextButtonEnabled
            .sink { [weak self] value in
                self?.nextButton.isEnabled = value
            }
            .store(in: &bag)
        
        output.didChangedSelectableType
            .compactMap { $0 }
            .sink { [weak self] type in
                self?.collectionView.reloadData()
                self?.registerHeaderStackView.setMessage(
                    guideText: type.guideText,
                    descriptionText: type.descriptionText
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
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

extension RegisterSelectableViewController: UINavigationControllerDelegate, ProgressAnimatable {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
            transition.operation = operation
            
            return transition
    }
    
    func preset() {
        progressBar.isHidden = true
        nextButton.isHidden = true
        view.backgroundColor = .clear
    }
    
    func progressingComponents() -> [UIView] {
        return [registerHeaderStackView, collectionView]
    }
    
    func reset() {
        progressBar.isHidden = false
        nextButton.isHidden = false
        view.backgroundColor = .white
    }
}

extension RegisterSelectableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selectableType = viewModel?.type else { return 0 }
        return selectableType.cases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let selectableType = viewModel?.type,
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
