//
//  CertificationNumberViewController.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit

class CertificationNumberViewController: UIViewController {
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "인증코드를 \n입력해주세요"
        label.numberOfLines = 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attr: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attrString = NSMutableAttributedString(
            string: label.text ?? "",
            attributes: attr)
        label.attributedText = attrString
        label.font = UIFont.systemFont(ofSize: 22, weight: .init(700))
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

}

// MARK: - Private functions

private extension CertificationNumberViewController {
    
    func configureUI() {
        
        NSLayoutConstraint.activate([
            self.guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI
struct CertificationNumberViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CertificationNumberViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                CertificationNumberViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
