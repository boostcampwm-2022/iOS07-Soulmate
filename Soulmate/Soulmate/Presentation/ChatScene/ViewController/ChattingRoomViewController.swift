//
//  ChattingRoomViewController.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit

final class ChattingRoomViewController: UIViewController {
    
    private var data: [Chat] = [
        Chat(isMe: false, text: "Cupcake?"),
        Chat(isMe: true, text: "VI?"),
        Chat(isMe: false, text: "Cupcake?"),
        Chat(isMe: true, text: "VI?"),
        Chat(isMe: false, text: "Cupcake?"),
        Chat(isMe: true, text: "VI?"),
        Chat(isMe: false, text: "Cupcake?"),
        Chat(isMe: true, text: "VI?"),
        Chat(isMe: false, text: "Cupcake?"),
        Chat(isMe: true, text: "VI?")
    ]
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyChatCell.self, forCellReuseIdentifier: MyChatCell.id)
        tableView.register(OtherChatCell.self, forCellReuseIdentifier: OtherChatCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
    }
}

extension ChattingRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = data[indexPath.row]
        
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

private extension ChattingRoomViewController {
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
