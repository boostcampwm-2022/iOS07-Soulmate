//
//  DistanceViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/29.
//

import UIKit
import Combine

import SnapKit

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
    
    private lazy var customSlider: CustomSlider = {
        let slider = CustomSlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 4
        slider.tintColor = .mainPurple
        slider.minimumTrackTintColor = .borderPurple
        slider.isContinuous = false
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

    override func viewDidLayoutSubviews() {
        configureSlider()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel?.finishDistanceSetting()
    }
    
//    @objc func sliderValueDidChange(sender: UISlider) {
////        let step: Float = 1
////        let roundedValue = round(sender.value / step) * step
////        sender.value = roundedValue
//        print(sender.value)
//    }
}

// MARK: Configure View Controller

private extension DistanceViewController {
    func bind() {
        guard let viewModel = viewModel else { return }
        
        let sliderPublisher = customSlider
            .valuePublisher()
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(
            input: DistanceViewModel.Input(
                didChangedSliderValue: sliderPublisher
            )
        )
        
        output.didChangedDistanceValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.distanceMessageLabel.text = "\(Int(value))km 내의 메이트만 탐색할게요!"
                switch value {
                case 5:
                    self?.customSlider.value = 0
                case 10:
                    self?.customSlider.value = 1
                case 20:
                    self?.customSlider.value = 2
                case 50:
                    self?.customSlider.value = 3
                case 1000:
                    self?.customSlider.value = 4
                default:
                    fatalError()
                }
            }
            .store(in: &bag)
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
//        customSlider.addTarget(self, action:#selector(sliderValueDidChange(sender:)), for: .valueChanged)
    }
    
    func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        customSlider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            //$0.top.equalTo(registerHeaderStackView.snp.bottom).offset(30)
            $0.centerY.equalToSuperview().offset(-20)
            $0.height.equalTo(10)
        }
        
        distanceMessageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)

        }
    }
    
    func configureSlider() {
        let thumb = customSlider.thumbImage(radius: 30)
        customSlider.setThumbImage(thumb, for: .normal)
        var views = [UIView(), UIView(), UIView(), UIView()]
        for i in 1..<views.count {
            views[i] = UIView(frame: CGRect(x: 11 + ((customSlider.frame.size.width - 24) / 4) * CGFloat(i),
                                            y: (customSlider.frame.size.height) / 3,
                                            width: 2,
                                            height: 12))
            views[i].backgroundColor = .white
            views[i].isUserInteractionEnabled = false
            customSlider.insertSubview(views[i], belowSubview: customSlider)
        }
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
