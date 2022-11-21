//
//  MbtiViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/17.
//

import UIKit
import SnapKit
import Combine

final class RegisterMbtiView: UIView {
    
    var bag = Set<AnyCancellable>()
    
    private lazy var registerHeaderStackView: RegisterHeaderStackView = {
        let headerView = RegisterHeaderStackView(frame: .zero)
        headerView.setMessage(guideText: "회원님의 MBTI를\n선택해주세요.")
        self.addSubview(headerView)
        return headerView
    }()
    
    private lazy var preview: MbtiPreview = {
        let preview = MbtiPreview()
        self.addSubview(preview)
        return preview
    }()
    
    private lazy var innerTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("I", "E"))
        self.addSubview(view)
        return view
    }()

    private lazy var recognizeTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("N", "S"))
        self.addSubview(view)
        return view
    }()
    
    private lazy var judgementTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("F", "T"))
        self.addSubview(view)
        return view
    }()
    
    private lazy var lifeStyleTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("P", "J"))
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mbtiPublisher() -> AnyPublisher<String?, Never> {
        return Publishers.CombineLatest4(
            innerTypeView.$seletedMbti.eraseToAnyPublisher(),
            recognizeTypeView.$seletedMbti.eraseToAnyPublisher(),
            judgementTypeView.$seletedMbti.eraseToAnyPublisher(),
            lifeStyleTypeView.$seletedMbti.eraseToAnyPublisher()
        )
        .map { (m, b, t, i) -> String? in
            guard !m.isEmpty,
                  !b.isEmpty,
                  !t.isEmpty,
                  !i.isEmpty else { return nil }
            return m+b+t+i
        }
        .eraseToAnyPublisher()
    }

}

private extension RegisterMbtiView {
    
    func bind() {

        innerTypeView.$seletedMbti.sink {
            self.preview.innerTypeLabel.text = $0
            if !$0.isEmpty {
                self.preview.innerTypeLabel.textColor = .black
            } else {
                self.preview.innerTypeLabel.text = "?"
            }
        }
        .store(in: &bag)
        
        recognizeTypeView.$seletedMbti.sink {
            self.preview.recognizeTypeLabel.text = $0
            if !$0.isEmpty {
                self.preview.recognizeTypeLabel.textColor = .black
            } else {
                self.preview.recognizeTypeLabel.text = "?"
            }
        }
        .store(in: &bag)
        
        judgementTypeView.$seletedMbti.sink {
            self.preview.judgementTypeLabel.text = $0
            if !$0.isEmpty {
                self.preview.judgementTypeLabel.textColor = .black
            } else {
                self.preview.judgementTypeLabel.text = "?"
            }
        }
        .store(in: &bag)
        
        lifeStyleTypeView.$seletedMbti.sink {
            self.preview.lifeStyleTypeLabel.text = $0
            if !$0.isEmpty {
                self.preview.lifeStyleTypeLabel.textColor = .black
            } else {
                self.preview.lifeStyleTypeLabel.text = "?"
            }
        }
        .store(in: &bag)
    }
    
    func configureLayout() {
        registerHeaderStackView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            //$0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)

        }
        
        preview.snp.makeConstraints {
            $0.top.equalTo(registerHeaderStackView.snp.bottom).offset(60)
            $0.width.equalTo(169)
            $0.centerX.equalToSuperview()
        }
        
        innerTypeView.snp.makeConstraints {
            $0.top.equalTo(preview.snp.bottom).offset(60)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
        
        recognizeTypeView.snp.makeConstraints {
            $0.top.equalTo(innerTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
        
        judgementTypeView.snp.makeConstraints {
            $0.top.equalTo(recognizeTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
        
        lifeStyleTypeView.snp.makeConstraints {
            $0.top.equalTo(judgementTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
    }
    
}
