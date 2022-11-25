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
    private var receivedChatRequestsViewController: ReceivedChatRequestsViewController?
    
    private lazy var viewControllers: [UIViewController] = {
        
        guard let chatRoomListViewController, let receivedChatRequestsViewController else { return [] }
        
        return [chatRoomListViewController, receivedChatRequestsViewController]
    }()
    
    private lazy var pageNavigationView: PageNavigationView = {
        let navView = PageNavigationView()
        view.addSubview(navView)
        navView.translatesAutoresizingMaskIntoConstraints = false
        navView.configure(
            with: ["채팅 목록", "받은 요청"],
            delegate: self
        )
        navView.setPage(index: 0)
        
        return navView
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
    
    convenience init(
        chatRoomListViewController: ChatRoomListViewController,
        receivedChatRequestsViewController: ReceivedChatRequestsViewController
    ) {
        self.init(nibName: nil, bundle: nil)
        self.chatRoomListViewController = chatRoomListViewController
        self.receivedChatRequestsViewController = receivedChatRequestsViewController
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
        pageNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(pageNavigationView.snp.bottom)
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
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        
            guard completed,
                  let currentViewController = pageViewController.viewControllers?.first,
                  let index = viewControllers.firstIndex(of: currentViewController) else { return }
            
            pageNavigationView.setPage(index: index)
    }
}

extension ChatScenePageViewController: PageChangeDelegate {
    func goToPage(by index: Int) {
        
        if 0..<viewControllers.count ~= index {
            let vc = viewControllers[index]
            pageViewController.setViewControllers(
                [vc],
                direction: index == 1 ? .forward : .reverse,
                animated: true
            )
            pageNavigationView.setPage(index: index)
        }
    }
}

extension ChatScenePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let prevIndex = index - 1
        if prevIndex < 0 { return viewControllers[viewControllers.count - 1] }
        
        return viewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        if nextIndex == viewControllers.count { return viewControllers[0] }
        
        return viewControllers[nextIndex]
    }
}
