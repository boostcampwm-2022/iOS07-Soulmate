//
//  LaunchViewController.swift
//  Soulmate
//
//  Created by termblur on 2022/11/29.
//

import UIKit

import SnapKit

final class LaunchViewController: UIViewController {
    lazy var animator = UIDynamicAnimator(referenceView: logoImage as UIView)
    lazy var gravity = UIGravityBehavior()
    lazy var collider = UICollisionBehavior()
    lazy var dynamicItemBehavior = UIDynamicItemBehavior()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let confettiImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Confetti")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .borderPurple
        self.view.addSubview(logoImage)
        self.view.addSubview(confettiImage)

        animatedLayout()
    }
    
    private func animatedLayout() {
        logoImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        confettiImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                self.view.backgroundColor = .white
                
                self.logoImage.alpha = 0.05
                self.logoImage.transform = CGAffineTransform(scaleX: 10, y: 10)
                 
                self.confettiImage.alpha = 0
            },
            completion: nil
        )
    }
}

#if DEBUG
import SwiftUI
struct LaunchViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        LaunchViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                LaunchViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
