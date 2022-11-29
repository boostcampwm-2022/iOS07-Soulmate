//
//  DistanceViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/29.
//

import UIKit
import Combine

class DistanceViewModel {
    var cancellables = Set<AnyCancellable>()
    
    //@Published var mateFilteringDistance: Double?
    
    struct Input {
        var didChangedDistanceValue: AnyPublisher<Double, Never>
    }
    
    struct Output {}
    
    init() {}
    
    func transform(input: Input) -> Output {
        input.didChangedDistanceValue
            .sink { [weak self] value in
                self?.setDistance(distance: value)
            }
            .store(in: &cancellables)
        return Output()
    }
    
    func setDistance(distance: Double) {
        
    }
}

class DistanceViewController: UIViewController {
    var bag = Set<AnyCancellable>()
    
    var viewModel: DistanceViewModel?
    
    lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(
            guideText: "메이트와 나의 거리를 설정합니다!",
            descriptionText: "선택한 범위의 메이트만 볼 수 있어요"
        )
        self.view.addSubview(headerView)
        return headerView
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 4
        slider.tintColor = .mainPurple
        self.view.addSubview(slider)
        return slider
    }()
    
    lazy var distanceMessageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        self.view.addSubview(label)
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: DistanceViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        
        bind()
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let sliderPublihser = slider
            .valuePublisher()
            .removeDuplicates()
            .map { value -> Double in
                switch value {
                case 0:
                    return 5
                case 1:
                    return 10
                case 2:
                    return 20
                case 3:
                    return 50
                case 4:
                    return 1000
                default:
                    fatalError()
                }
            }
            .eraseToAnyPublisher()
        
        sliderPublihser
            .sink { [weak self] value in
                DispatchQueue.main.async {
                    if value == 1000 {
                        self?.distanceMessageLabel.text = "모든 메이트를 탐색할게요!"
                    }
                    else {
                        self?.distanceMessageLabel.text = "\(Int(value))km 내의 메이트만 탐색할게요!"
                    }
                }
            }
            .store(in: &bag)
        
        viewModel.transform(
            input: DistanceViewModel.Input(
                didChangedDistanceValue: sliderPublihser
            )
        )
        
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        slider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)

    }
    
    func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        slider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.top.equalTo(registerHeaderStackView.snp.bottom).offset(30)
            $0.height.equalTo(10)
        }
        
        distanceMessageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(slider.snp.bottom).offset(30)
        }
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
}

// MARK: - 미리보기
#if DEBUG
import SwiftUI
struct DistanceControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        DistanceViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                DistanceControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
