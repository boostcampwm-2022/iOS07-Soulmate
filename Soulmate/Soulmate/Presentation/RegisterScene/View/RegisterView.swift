//
//  RegisterView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import UIKit
import SnapKit
import Combine

final class RegisterView: UIView {
    @Published var currentPage: Int = 0

    // MARK: - UI Components
    
    var childView = [
        RegisterSelectableView<GenderType>(),
        RegisterNickNameView(),
        RegisterBirthView(),
        RegisterHeightView(),
        RegisterMbtiView(),
        RegisterSelectableView<SmokingType>(),
        RegisterSelectableView<DrinkingType>(),
        RegisterIntroductionView(),
        RegisterPhotoView(),
        RegisterCongraturationsView()
    ]
    
    private lazy var progressBar: ProgressBar = {
        let bar = ProgressBar(frame: .zero)
        self.addSubview(bar)
        return bar
    }()
    
    lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.addSubview(button)
        return button
    }()
    
    lazy var prevButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension RegisterView {
    func configureView() {
        self.backgroundColor = .systemBackground
        childView.forEach {
            self.addSubview($0)
        }
    }
    
    // MARK: Page 이외의 subview 레이아웃
    func configureLayout() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.height.equalTo(54)
        }
    }
    
    // MARK: 페이지 레이아웃 초기 셋팅
    func configurePageLayout() {
    
        for i in 0..<currentPage {
            progressBar.goToNextStep()
            childView[i].snp.remakeConstraints {
                $0.trailing.equalTo(self.snp.leading)
                $0.centerY.equalTo(self.snp.centerY)
                $0.width.height.equalToSuperview()
            }
        }
        
        childView[currentPage].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        for i in currentPage + 1..<childView.count {
            childView[i].snp.remakeConstraints {
                $0.centerY.equalTo(self.snp.centerY)
                $0.leading.equalTo(self.snp.trailing)
                $0.width.height.equalToSuperview()
            }
        }
    }
}

// MARK: Page Animation

extension RegisterView {
    func nextPage() {
        progressBar.goToNextStep()
        
        childView[currentPage].snp.remakeConstraints {
            $0.trailing.equalTo(self.snp.leading)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        childView[currentPage + 1].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        animate()
        currentPage += 1
    }
    
    func prevPage() {
        progressBar.goToExStep()

        childView[currentPage].snp.remakeConstraints {
            $0.leading.equalTo(self.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        childView[currentPage - 1].snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }

        animate()
        currentPage -= 1
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2) {
          self.layoutIfNeeded()
        }
    }
}
