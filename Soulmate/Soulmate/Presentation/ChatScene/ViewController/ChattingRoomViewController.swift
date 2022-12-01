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
    private var messageSendSubject: AnyPublisher<Void, Never>?
    
    private var isInitLoad = true
    private var isLoading = false
    
    private var dataSource: DataSource?
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
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
    
    convenience init(viewModel: ChattingRoomViewModel, chatRoomInfo: ChatRoomInfo) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.chatRoomInfo = chatRoomInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        setPublishers()
        createDataSource()
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

extension ChattingRoomViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Chat>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Chat>
    
    func loadData(_ chats: [Chat]) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func dataInsert(_ chats: [Chat]) {
        
        guard var snapshot = dataSource?.snapshot(),
              let firstItem = snapshot.itemIdentifiers.first else { return }
        
        let beforeHeight = chatTableView.contentSize.height
        
        print("before: ", chatTableView.contentOffset.y)
        
        snapshot.insertItems(chats, beforeItem: firstItem)
        dataSource?.apply(snapshot, animatingDifferences: false)
                
        let afterHeight = chatTableView.contentSize.height
        
        print("after: ", chatTableView.contentOffset.y)
    }
    
    func dataAppend(_ chats: [Chat]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        snapshot.appendItems(chats)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createDataSource() {
        dataSource = DataSource(
            tableView: chatTableView,
            cellProvider: { [weak self] tableView, indexPath, chat in

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
                    
                    Task {
                        guard let profileImageData = await self?.viewModel?.fetchProfileImage(of: chat.userId) else { return }
                        guard let image = UIImage(data: profileImageData) else { return }
                        
                        if self?.chatTableView.cellForRow(at: indexPath) != nil {
                            await MainActor.run {
                                
                                cell.set(image: image)
                            }
                        }
                    }

                    return cell
                }
        })
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
extension ChattingRoomViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isInitLoad, !isLoading else { return }
                                
        if scrollView.contentOffset.y < chatTableView.bounds.size.height &&
            !chatTableView.isTracking &&
            scrollView.contentOffset.y > 0 {
            
            loadPrevChattings()
        }
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

// MARK: - UI Configure
private extension ChattingRoomViewController {
    func configureView() {
        
        let hideKeyboardButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(hideKeyboard)
        )
        
        let loadPrevChattingsButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.message"),
            style: .plain,
            target: self,
            action: #selector(loadPrevChattings)
        )
        
        self.navigationItem.rightBarButtonItems = [
            hideKeyboardButton,
            loadPrevChattingsButton
        ]
        
        self.title = chatRoomInfo?.mateName
        view.backgroundColor = .white
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func loadPrevChattings() {
        isLoading = true
        loadPrevChattingsSubject.send(())
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
            .sink { [weak self] chats in
                
                if self?.isInitLoad ?? false {
                    self?.loadData(chats)
                    self?.isInitLoad = false
                    self?.scrollToBottom()
                }
            }
            .store(in: &cancellabels)
        
        output.unreadChattingLoaded
            .sink { [weak self] chats in
                self?.dataAppend(chats)
            }
            .store(in: &cancellabels)
        
        output.prevChattingLoaded
            .sink { [weak self] chats in

                self?.dataInsert(chats)
                self?.isLoading = false
            }
            .store(in: &cancellabels)
        
//        output.newMessageArrived
//            .sink { [weak self] count in
//
////                var indexPathes: [IndexPath] = []
////
////                (1...count).forEach { i in
////                    let indexPath = IndexPath(row: viewModel.chattings.count - i, section: 0)
////
////                    indexPathes.append(indexPath)
////                }
//
//                let diff = (self?.bottomOffset().y ?? 0) - (self?.chatTableView.contentOffset.y ?? 0)
//
////                self?.chatTableView.performBatchUpdates({
////                    self?.chatTableView.insertRows(at: indexPathes, with: .none)
////                }, completion: { _ in
////
////                })
//
//                if let chats = self?.viewModel?.chattings {
//                    self?.loadData(chats)
//                }
//
//                if diff < 10 {
//                    self?.scrollToBottom()
//                }
//            }
//            .store(in: &cancellabels)
//
//        output.chatUpdated
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] row in
//
//                if let chats = self?.viewModel?.chattings {
//                    self?.loadData(chats)
//                }
//            }
//            .store(in: &cancellabels)
    }
}

// MARK: - 가장 아래로 스크롤
private extension ChattingRoomViewController {
    
    func scrollToBottom() {
        guard let snapshot = dataSource?.snapshot() else { return }
        
        chatTableView.scrollToRow(
            at: IndexPath(
                row: snapshot.itemIdentifiers.count - 1,
                section: 0
            ),
            at: .bottom, animated: false
        )
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
    
    func adjustContentForKeyboard(with height: CGFloat) {
        let safeLayoutBottomHeight = view.frame.maxY - view.safeAreaLayoutGuide.layoutFrame.maxY
        let keyboardHeight = height == 0 ? 0 : height - safeLayoutBottomHeight
        
        let distanceFromBottom = bottomOffset().y - chatTableView.contentOffset.y
        
        var insets = chatTableView.contentInset
        insets.bottom = keyboardHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            
            self.composeBar.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
            }
            self.chatTableView.contentInset = insets
            self.chatTableView.scrollIndicatorInsets = insets
            self.view.layoutIfNeeded()
            
            if distanceFromBottom < 10 {
                self.chatTableView.contentOffset = self.bottomOffset()
            }
        }, completion: nil)
    }
}
