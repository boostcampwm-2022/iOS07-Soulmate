//
//  ChattingRoomViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import UIKit

final class ChattingRoomViewController: UIViewController {
    
    private var viewModel: ChattingRoomViewModel?
    private var cancellabels = Set<AnyCancellable>()
    private var messageSubject = PassthroughSubject<String?, Never>()
    
    private var shouldScrollToBottom = true
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyChatCell.self, forCellReuseIdentifier: MyChatCell.id)
        tableView.register(OtherChatCell.self, forCellReuseIdentifier: OtherChatCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
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
    
    convenience init(viewModel: ChattingRoomViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureView()
        configureLayout()
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            scrollToBottom(animated: false)
        }
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


// MARK: - TableView Delegae, DataSource
extension ChattingRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chattings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let chat = viewModel?.chattings[indexPath.row] else {
            return UITableViewCell()
        }

        if chat.isMe {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyChatCell.id,
                for: indexPath) as? MyChatCell else {

                return UITableViewCell()
            }

            cell.configure(from: chat)

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OtherChatCell.id,
                for: indexPath) as? OtherChatCell else {

                return UITableViewCell()
            }

            cell.configure(from: chat)

            return cell
        }
    }
}

// MARK: - UI Configure
private extension ChattingRoomViewController {
    func configureView() {
        self.title = "메이트 이름"
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        
        view.addSubview(chatTableView)
        view.addSubview(composeBar)
        
        composeBar.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(50)
        }
        
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(composeBar.snp.top)
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
                message: messageSubject.eraseToAnyPublisher(),
                sendButtonDidTap: composeBar.sendButtonPublisher()
            ),
            cancellables: &cancellabels
        )
        
        output.sendButtonEnabled
            .sink { [weak self] isEnabled in
                
                if isEnabled {
                    self?.composeBar.activateSendButton()
                } else {
                    self?.composeBar.deactivateSendButton()
                }
            }
            .store(in: &cancellabels)
        
        output.chattingsLoaded
            .sink { [weak self] _ in
                self?.chatTableView.reloadData()
                self?.scrollToBottom(animated: false)
            }
            .store(in: &cancellabels)
    }
}

// MARK: - 가장 아래로 스크롤
private extension ChattingRoomViewController {
    
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        chatTableView.setContentOffset(bottomOffset(), animated: animated)
    }
    
    func bottomOffset() -> CGPoint {
        return CGPoint(
            x: 0,
            y: max(-chatTableView.contentInset.top, chatTableView.contentSize.height - (chatTableView.bounds.size.height - chatTableView.contentInset.bottom))
        )
    }
}

// MARK: - 키보트 높이에 따라 TableView 변경
private extension ChattingRoomViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
     
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }
     
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }
     
    func adjustContentForKeyboard(shown: Bool, notification: NSNotification) {
        guard let payload = KeyboardInfo(notification as Notification) else { return }
        
        let safeLayoutBottomHeight = view.frame.maxY - view.safeAreaLayoutGuide.layoutFrame.maxY
        let keyboardHeight = shown ? payload.frameEnd.size.height - safeLayoutBottomHeight : 0
        
        if chatTableView.contentInset.bottom == keyboardHeight {
            return
        }
     
        let distanceFromBottom = bottomOffset().y - chatTableView.contentOffset.y
     
        var insets = chatTableView.contentInset
        insets.bottom = keyboardHeight
     
        UIView.animate(withDuration: payload.animationDuration, delay: 0, options: [], animations: {
            
            self.composeBar.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
            }
            
            self.view.layoutIfNeeded()
            
            if distanceFromBottom < 10 {
                self.chatTableView.contentOffset = self.bottomOffset()
            }
        }, completion: nil)
    }
}
