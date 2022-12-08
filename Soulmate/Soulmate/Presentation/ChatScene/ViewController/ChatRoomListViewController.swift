//
//  ChatRoomListViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import UIKit
import SnapKit
import Combine

final class ChatRoomListViewController: UIViewController {
    
    private var viewModel: ChatRoomListViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let rowSelectSubject = PassthroughSubject<Int, Never>()
    
    private lazy var chattingListView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ChatRoomInfoCell.self, forCellReuseIdentifier: ChatRoomInfoCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ChatRoomListViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureView()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

private extension ChatRoomListViewController {
    
    func bind() {
        let output = viewModel?.transform(
            input: ChatRoomListViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                didSelectRowAt: rowSelectSubject.eraseToAnyPublisher()
            ),
            cancellables: &cancellables
        )
        
        output?.listLoaded
            .sink { [weak self] _ in
                self?.chattingListView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func configureView() {
        self.title = "채팅 목록"
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        chattingListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.trailing.equalTo(view.snp.trailing)
        }
    }
}

extension ChatRoomListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chattingList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let info = viewModel?.chattingList[indexPath.row],
              let uid = viewModel?.userUid() else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatRoomInfoCell.id,
            for: indexPath) as? ChatRoomInfoCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: info, uid: uid)
        
        Task {
            guard let otherId = info.userIds.first(where: { $0 != uid }),
                  let imageKey = info.userProfileImages[otherId],
                  let imageData = await self.viewModel?.fetchProfileImage(key: imageKey),
                  let uiImage = UIImage(data: imageData) else { return }
            
            if tableView.cellForRow(at: indexPath) != nil {
                await MainActor.run { cell.configure(image: uiImage) }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelectSubject.send(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
