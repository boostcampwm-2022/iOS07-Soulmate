//
//  MbtiViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/17.
//

import UIKit
import SnapKit

class MbtiViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님의 MBTI를\n선택해주세요."
        label.numberOfLines = 2
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var preview: MbtiPreview = {
        let preview = MbtiPreview()
        self.view.addSubview(preview)
        return preview
    }()
    
//    var innerType: InnerType
//    var recognizeType: RecognizeType
//    var judgementType: JudgementType
//    var lifeStyleType: LifeStyleType
    
    private lazy var innerTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("I", "E"))
        self.view.addSubview(view)
        return view
    }()

    private lazy var recognizeTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("N", "S"))
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var judgementTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("F", "T"))
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var lifeStyleTypeView: MbtiSegmentView = {
        let view = MbtiSegmentView(titles: ("P", "J"))
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var nextButton: GradientButton = {
        let button = GradientButton(title: "다음")
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        configureLayout()
    }

}

private extension MbtiViewController {
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        preview.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.width.equalTo(169)
            $0.centerX.equalToSuperview()
        }
        
        innerTypeView.snp.makeConstraints {
            $0.top.equalTo(preview.snp.bottom).offset(60)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        recognizeTypeView.snp.makeConstraints {
            $0.top.equalTo(innerTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        judgementTypeView.snp.makeConstraints {
            $0.top.equalTo(recognizeTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        lifeStyleTypeView.snp.makeConstraints {
            $0.top.equalTo(judgementTypeView.snp.bottom).offset(24)
            $0.width.equalTo(350)
            $0.height.equalTo(50)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(54)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }
}
