//
//  MyPageViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    
    lazy var contentView = MyPageView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // binding
        // viewModel -> view
        // view -> viewModel
    }
    
    
}
