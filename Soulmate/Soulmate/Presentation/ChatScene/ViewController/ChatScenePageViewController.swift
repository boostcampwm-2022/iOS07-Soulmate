//
//  ChatScenePageViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import UIKit
import SnapKit

final class ChatScenePageViewController: UIViewController {
    
    
    private var chatRoomListViewController: ChatRoomListViewController?
    
    private lazy var viewControllers: [UIViewController] = {
        
        guard let chatRoomListViewController else { return [] }
        
        return [chatRoomListViewController]
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.delegate = self
        pageVC.dataSource = self
        view.addSubview(pageVC.view)
        
        return pageVC
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(chatRoomListViewController: ChatRoomListViewController) {
        self.init(nibName: nil, bundle: nil)
        self.chatRoomListViewController = chatRoomListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureView()
        configureLayout()
        setPageViewController()
    }
}

private extension ChatScenePageViewController {
    
    func bind() {
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    func configureLayout() {
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ChatScenePageViewController {
    func setPageViewController() {
        if let initVC = viewControllers.first {
            pageViewController.setViewControllers([initVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension ChatScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = index - 1
        if prevIndex < 0 { return nil }
        
        return viewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        if nextIndex == viewControllers.count { return nil }
        
        return viewControllers[nextIndex]
    }
}
