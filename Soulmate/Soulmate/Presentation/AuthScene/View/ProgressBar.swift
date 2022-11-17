//
//  ProgressBar.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/15.
//

import UIKit
import SnapKit

class ProgressBar: UIView {

    private var step = 0
    
    private lazy var totalBar: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGrey
        view.layer.cornerRadius = 3
        view.layer.cornerCurve = .continuous
        self.addSubview(view)
        return view
    }()
    
    private lazy var internalBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPurple
        view.layer.cornerRadius = 3
        view.layer.cornerCurve = .continuous
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToNextStep() {
        self.step += 1
        internalBar.snp.updateConstraints {
            $0.width.equalTo(Double(UIScreen.main.bounds.width) / 10 * Double(step))
        }
    }
    
    func goToExStep() {
        self.step -= 1
        internalBar.snp.updateConstraints {
            $0.width.equalTo(Double(UIScreen.main.bounds.width) / 10 * Double(step))
        }
    }
    
}

private extension ProgressBar {
    
    func configureLayout() {
        totalBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        internalBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(Double(UIScreen.main.bounds.width) / 10 * Double(step))
            $0.height.equalTo(6)
        }
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ProgressBarPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let bar = ProgressBar(frame: .zero)
            return bar
        }.previewLayout(.fixed(width: 300, height: 6))
    }
}
#endif
