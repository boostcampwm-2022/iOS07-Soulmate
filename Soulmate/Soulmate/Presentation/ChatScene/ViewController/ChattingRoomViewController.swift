//
//  ChattingRoomViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import UIKit

final class ChattingRoomViewController: UIViewController {
    
    private var chatRoomInfo: ChatRoomInfo?
    private var viewModel: ChattingRoomViewModel?
    private var cancellabels = Set<AnyCancellable>()
    private var messageSubject = PassthroughSubject<String?, Never>()
    private var loadPrevChattingsSubject = PassthroughSubject<Void, Never>()
    private var newLineInputSubject = PassthroughSubject<Void, Never>()
    private var viewWillDisappearSubject = PassthroughSubject<Void, Never>()
    private var resignActiveSubject = PassthroughSubject<Void, Never>()
    private var didBecomeActiveSubejct = PassthroughSubject<Void, Never>()
    private var messageSendSubject: AnyPublisher<Void, Never>?
    
    private var isInitLoad = true
    
    private lazy var chatListView: ChatListView = {
        let listView = ChatListView(hostView: self.view)
        listView.loadPrevChatDelegate = self
        
        return listView
    }()
    
    private lazy var composeBar: ComposeBar = {
        let messageInputView = ComposeBar()
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.configure(with: self)
        
        return messageInputView
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ChattingRoomViewModel, chatRoomInfo: ChatRoomInfo) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.chatRoomInfo = chatRoomInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        configureView()
        configureLayout()
        setPublishers()
        addNotifications()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewWillDisappearSubject.send(())
    }
}

// MARK: - Notification
extension ChattingRoomViewController {
    func addNotifications() {
        
        let resignNotificationCenter = NotificationCenter.default
        
        resignNotificationCenter.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        let activeNotificationCenter = NotificationCenter.default
        
        activeNotificationCenter.addObserver(
            self,
            selector: #selector(appDidActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc
    func appMovedToBackground() {
        resignActiveSubject.send(())
    }
    
    @objc
    func appDidActive() {
        didBecomeActiveSubejct.send(())
    }
}

// MARK: - TextView Delegate
extension ChattingRoomViewController: NSTextStorageDelegate {
    func textStorage(
        _ textStorage: NSTextStorage,
        didProcessEditing editedMask: NSTextStorage.EditActions,
        range editedRange: NSRange,
        changeInLength delta: Int) {
            messageSubject.send(textStorage.string)
    }
}

// MARK: - Load Prev Chats Delegate
extension ChattingRoomViewController: LoadPrevChatDelegate {
    func loadPrevChats() {
        
        loadPrevChattingsSubject.send(())
    }
}

// MARK: - Set Publishers
private extension ChattingRoomViewController {
    
    func setPublishers() {
        messageSendSubject = newLineInputSubject
            .merge(with: composeBar.sendButtonPublisher())
            .eraseToAnyPublisher()
    }
}

// MARK: - gestures
private extension ChattingRoomViewController {
    
    func addGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapRecognizer)
    }
}

// MARK: - UI Configure
private extension ChattingRoomViewController {
    func configureView() {
            
        Task {
            let mateName = await viewModel?.mateName()
            await MainActor.run {
                self.title = mateName
            }
        }
        
        view.backgroundColor = .white
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }

    func configureLayout() {
        
        view.addSubview(chatListView)
        view.addSubview(composeBar)
        
        composeBar.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(50)
        }
        
        chatListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
    }
}

// MARK: - ViewModel Binding
private extension ChattingRoomViewController {
    
    func bind() {
        
        guard let viewModel else { return }
        
        let output = viewModel.transform(
            input: ChattingRoomViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                viewWillDisappear: viewWillDisappearSubject.eraseToAnyPublisher(),
                resignActive: resignActiveSubject.eraseToAnyPublisher(),
                didBecomeActive: didBecomeActiveSubejct.eraseToAnyPublisher(),
                message: messageSubject.eraseToAnyPublisher(),
                messageSendEvent: messageSendSubject,
                loadPrevChattings: loadPrevChattingsSubject.eraseToAnyPublisher()
            ),
            cancellables: &cancellabels
        )
        
        output.keyboardHeight
            .sink { [weak self] height in
                if self?.isInitLoad ?? false { return }
                self?.adjustContentForKeyboard(with: height)
            }
            .store(in: &cancellabels)
        
        output.sendButtonEnabled
            .sink { [weak self] isEnabled in
                
                if isEnabled {
                    self?.composeBar.activateSendButton()
                } else {
                    self?.composeBar.deactivateSendButton()
                }
            }
            .store(in: &cancellabels)
        
        output.chattingInitLoaded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                
                guard !chats.isEmpty else {
                    self?.isInitLoad = false
                    return
                }
                
                if self?.isInitLoad ?? false {
                    self?.chatListView.load(chats)
                    self?.isInitLoad = false
                    self?.chatListView.scrollToBottomByOffset()
                }
            }
            .store(in: &cancellabels)
        
        output.unreadChattingLoaded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in                
                self?.chatListView.append(chats)
            }
            .store(in: &cancellabels)
        
        output.prevChattingLoaded
            .sink { [weak self] chats in                
                self?.chatListView.fillBuffer(with: chats)
            }
            .store(in: &cancellabels)
        
        output.newMessageArrived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                let diff = (self?.bottomOffset().y ?? 0) - (self?.chatListView.contentOffset.y ?? 0)
                self?.chatListView.append(chats)                 
                
                if diff < 10 {
                    self?.chatListView.scrollToBottomByOffset()
                }
            }
            .store(in: &cancellabels)

        output.chatUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chat in
                
                self?.chatListView.update(chat)
            }
            .store(in: &cancellabels)
        
        output.otherIsEntered
            .sink { othersId in
                self.chatListView.update(notContaining: othersId)
            }
            .store(in: &cancellabels)
    }
}

// MARK: - BottomOffset
private extension ChattingRoomViewController {

    func bottomOffset() -> CGPoint {
        
        return CGPoint(
            x: 0,
            y: max(
                -chatListView.contentInset.top,
                 chatListView.contentSize.height - (chatListView.bounds.size.height - chatListView.contentInset.bottom)
            )
        )
    }
}

// MARK: - 키보트 높이에 따라 ChatListView 변경
private extension ChattingRoomViewController {
    
    func adjustContentForKeyboard(with height: CGFloat) {
        let safeLayoutBottomHeight = view.frame.maxY - view.safeAreaLayoutGuide.layoutFrame.maxY
        let keyboardHeight = height == 0 ? 0 : height - safeLayoutBottomHeight
        
        let distanceFromBottom = bottomOffset().y - chatListView.contentOffset.y
        
        var insets = chatListView.contentInset
        insets.bottom = keyboardHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            
            self.composeBar.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
            }
            self.chatListView.contentInset = insets
            self.chatListView.scrollIndicatorInsets = insets
            self.view.layoutIfNeeded()
            
            if distanceFromBottom < 10 {
                self.chatListView.contentOffset = self.bottomOffset()
            }
        }, completion: nil)
    }
}
