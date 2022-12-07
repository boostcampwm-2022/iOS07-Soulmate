//
//  PhotoFooterView.swift
//  Soulmate
//
//  Created by termblur on 2022/11/22.
//

import UIKit
import Combine

import SnapKit

final class PhotoFooterView: UICollectionReusableView {
    
    static var footerKind = "Photo-Footer-View"
    
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.hidesForSinglePage = true
        control.currentPageIndicatorTintColor = .messagePurple
        control.pageIndicatorTintColor = .labelDarkGrey
        control.isUserInteractionEnabled = false
        self.addSubview(control)
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        pageControl.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func subscribeTo(totalPage: AnyPublisher<Int, Never>) {
        totalPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.pageControl.numberOfPages = value
            }
            .store(in: &cancellable)
    }
    
    func subscribeTo(currentPage: AnyPublisher<Int, Never>) {
        currentPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] page in
                self?.pageControl.currentPage = page
            }
            .store(in: &cancellable)
    }
}
