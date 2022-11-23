//
//  ChatListViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import UIKit
import SnapKit
import Combine

final class ChatListViewController: UIViewController {
    
    private var viewModel: ChatListViewModel?
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
    
    convenience init(viewModel: ChatListViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureView()
        configureLayout()
    }
}

private extension ChatListViewController {
    
    func bind() {
        let output = viewModel?.transform(
            input: ChatListViewModel.Input(
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

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chattingList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let info = viewModel?.chattingList[indexPath.row] else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatRoomInfoCell.id,
            for: indexPath) as? ChatRoomInfoCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: info)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelectSubject.send(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
