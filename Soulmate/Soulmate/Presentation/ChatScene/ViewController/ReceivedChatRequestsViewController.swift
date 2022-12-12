//
//  ReceivedChatRequestsViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import Combine
import UIKit

final class ReceivedChatRequestsViewController: UIViewController {
    
    private var viewModel: ReceivedChatRequestsViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var acceptSubject = PassthroughSubject<ReceivedMateRequest, Never>()
    private var denySubject = PassthroughSubject<String, Never>()
    
    private lazy var chatRequestsView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ReceivedChatRequestCell.self, forCellReuseIdentifier: ReceivedChatRequestCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: ReceivedChatRequestsViewModel) {
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
        
        if !NetworkMonitor.shared.isConnected {
            showPopUp(title: "네트워크 접속 불가🕸️",
                      message: "네트워크 연결 상태를 확인해주세요.",
                      leftActionTitle: "취소",
                      rightActionTitle: "설정",
                      rightActionCompletion: { // 설정 켜기
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
        }
    }
}

private extension ReceivedChatRequestsViewController {
    
    func bind() {
        let output = viewModel?.transform(
            input: ReceivedChatRequestsViewModel.Input(
                viewDidLoad: Just(()).eraseToAnyPublisher(),
                requestAccept: acceptSubject.eraseToAnyPublisher(),
                requestDeny: denySubject.eraseToAnyPublisher()
            ),
            cancellables: &cancellables
        )
        
        output?.requestsUpdated
            .sink { [weak self] _ in
                self?.chatRequestsView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func configureView() {
        
    }
    
    func configureLayout() {
        chatRequestsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.trailing.equalTo(view.snp.trailing)
        }
    }
}

extension ReceivedChatRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.requests.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let request = viewModel?.requests[indexPath.row] else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReceivedChatRequestCell.id,
            for: indexPath
        ) as? ReceivedChatRequestCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: request)
        cell.configureAccept { [weak self] in
            
            self?.acceptSubject.send(request)
        }
        cell.configureDeny { [weak self] in
            if let documentId = request.documentId {
                self?.denySubject.send(documentId)
            }
        }
        
        Task {
            guard let imageData = await self.viewModel?.fetchProfileImage(key: request.mateProfileImage),
                  let uiImage = UIImage(data: imageData) else { return }
            if tableView.cellForRow(at: indexPath) != nil {
                await MainActor.run { cell.configure(image: uiImage) }
            }
        }
        
        return cell
    }
    
    
}
