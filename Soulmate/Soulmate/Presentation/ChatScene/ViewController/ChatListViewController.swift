//
//  ChatListViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit
import Combine

class ChatListViewModel {
    @Published var chatRoomInfoList = [ChatRoomViewModelElement]()
    
    init() {
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요", matePicture: UIImage(named: "p1.png")!.pngData()!, latestChatContent: "안녕하세요 블라블라 한줄이 넘어가면 그뒤는 짤립니다", latestChatAt: "3시간 전", unreadMessageNumber: 2))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요2", matePicture: UIImage(named: "p1.png")!.pngData()!, latestChatContent: "안녕하세요 잘부탁드려요", latestChatAt: "1시간 전", unreadMessageNumber: 1))
        chatRoomInfoList.append(ChatRequestViewModel(mateName: "초록잎", matePicture: UIImage(named: "p2.png")!.pngData()!))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요3", matePicture: UIImage(named: "p2.png")!.pngData()!, latestChatContent: "대화 수락을 기다리고 있습니다.", latestChatAt: "", unreadMessageNumber: 0))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요", matePicture: UIImage(named: "p1.png")!.pngData()!, latestChatContent: "안녕하세요 블라블라 한줄이 넘어가면 그뒤는 짤립니다", latestChatAt: "3시간 전", unreadMessageNumber: 2))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요2", matePicture: UIImage(named: "p2.png")!.pngData()!, latestChatContent: "안녕하세요 잘부탁드려요", latestChatAt: "1시간 전", unreadMessageNumber: 1))
        chatRoomInfoList.append(ChatRequestViewModel(mateName: "초록잎", matePicture: UIImage(named: "p1.png")!.pngData()!))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요3", matePicture: UIImage(named: "p2.png")!.pngData()!, latestChatContent: "대화 수락을 기다리고 있습니다.", latestChatAt: "", unreadMessageNumber: 0))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요3", matePicture: UIImage(named: "p2.png")!.pngData()!, latestChatContent: "대화 수락을 기다리고 있습니다.", latestChatAt: "", unreadMessageNumber: 0))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요", matePicture: UIImage(named: "p1.png")!.pngData()!, latestChatContent: "안녕하세요 블라블라 한줄이 넘어가면 그뒤는 짤립니다", latestChatAt: "3시간 전", unreadMessageNumber: 2))
        chatRoomInfoList.append(ChatRoomInfoViewModel(mateName: "방가워요2", matePicture: UIImage(named: "p2.png")!.pngData()!, latestChatContent: "안녕하세요 잘부탁드려요", latestChatAt: "1시간 전", unreadMessageNumber: 1))
        chatRoomInfoList.append(ChatRequestViewModel(mateName: "초록잎", matePicture: UIImage(named: "p1.png")!.pngData()!))
    }
}


protocol ChatRoomViewModelElement {}

struct ChatRoomInfoViewModel: ChatRoomViewModelElement {
    var mateName: String
    var matePicture: Data
    var latestChatContent: String
    var latestChatAt: String
    var unreadMessageNumber: Int
}

struct ChatRequestViewModel: ChatRoomViewModelElement {
    var mateName: String
    var matePicture: Data
}

class NotificationCounter: UIView {
    lazy var counter: UILabel = {
        let label = UILabel(frame: .zero)
        self.addSubview(label)
        label.font = UIFont(name: "Poppins-Medium", size: 5)
        label.textColor = .white
        return label
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .mainPurple
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        counter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

class ChatInfoCell: UITableViewCell {
    
    lazy var mateImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 31
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var mateNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var latestChatTime: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.textColor = .labelGrey
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var latestChatContentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = .labelDarkGrey
        return label
    }()
    
    lazy var notificationCounter: NotificationCounter = {
        let counter = NotificationCounter(frame: .zero)
        return counter
    }()
    
    lazy var latestContentStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.addArrangedSubview(latestChatContentLabel)
        stackView.addArrangedSubview(notificationCounter)
        self.contentView.addSubview(stackView)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mateImageView.image = nil
        mateNameLabel.text = nil
        latestChatTime.text = nil
        latestChatContentLabel.text = nil
        notificationCounter.counter.text = nil
    }

    func configureLayout() {
        mateImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(62)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        
        mateNameLabel.snp.makeConstraints {
            $0.leading.equalTo(mateImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(21)
        }
        
        latestChatTime.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(mateNameLabel)
        }
        
        notificationCounter.snp.makeConstraints {
            $0.width.height.equalTo(22)
        }
        
        latestContentStackView.snp.makeConstraints {
            $0.leading.equalTo(mateImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(mateNameLabel.snp.bottom).offset(4)
            $0.height.equalTo(22)
        }
        
        var separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func fill(with viewModel: ChatRoomInfoViewModel) {
        mateImageView.image = UIImage(data: viewModel.matePicture)
        mateNameLabel.text = viewModel.mateName
        latestChatTime.text = viewModel.latestChatAt
        latestChatContentLabel.text = viewModel.latestChatContent
        if viewModel.unreadMessageNumber != 0 {
            notificationCounter.isHidden = false
            notificationCounter.counter.text = String(viewModel.unreadMessageNumber)
        }
        else {
            notificationCounter.isHidden = true
        }
        
    }
}

class ChatRequestCell: UITableViewCell {
    lazy var mateImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 31
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var mateNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var requestLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.text = "대화 요청이 도착했습니다!"
        label.textColor = .labelDarkGrey
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "friendAccept"), for: .normal)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "friendDelete"), for: .normal)
        self.contentView.addSubview(button)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .lightPurple
    }
    
    func configureLayout() {
        mateImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(62)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        
        mateNameLabel.snp.makeConstraints {
            $0.leading.equalTo(mateImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(21)
        }
        
        requestLabel.snp.makeConstraints {
            $0.leading.equalTo(mateImageView.snp.trailing).offset(16)
            $0.top.equalTo(mateNameLabel.snp.bottom).offset(4)
        }
        
        acceptButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(42)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(acceptButton.snp.leading).offset(-10)
            $0.width.height.equalTo(42)
        }

        var separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mateImageView.image = nil
        mateNameLabel.text = nil
    }
    
    func fill(with viewModel: ChatRequestViewModel) {
        mateImageView.image = UIImage(data: viewModel.matePicture)
        mateNameLabel.text = viewModel.mateName
    }
}

class ChatListViewController: UIViewController {
    var viewModel: ChatListViewModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(ChatInfoCell.self, forCellReuseIdentifier: "ChatInfoCell")
        tableView.register(ChatRequestCell.self, forCellReuseIdentifier: "ChatRequestCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ChatListViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    
    
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.chatRoomInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError() }
        
        let element = viewModel.chatRoomInfoList[indexPath.row]
        switch element {
        case let item as ChatRoomInfoViewModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInfoCell", for: indexPath) as? ChatInfoCell else { fatalError() }
            cell.fill(with: item)
            return cell
        case let item as ChatRequestViewModel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRequestCell", for: indexPath) as? ChatRequestCell else { fatalError() }
            cell.fill(with: item)
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
