//
//  CongraturationsViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/16.
//

import UIKit

final class CongraturationsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
}

private extension CongraturationsViewController {
    
    func configureLayout() {
        
    }
}

#if DEBUG
import SwiftUI
struct CongraturationsViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        CongraturationsViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                CongraturationsViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
