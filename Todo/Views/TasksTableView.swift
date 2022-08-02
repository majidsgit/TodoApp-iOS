//
//  TasksTableView.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit

class TaskTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: [Task]? = [] {
        didSet {
            reloadData()
        }
    }
    
    var deleteItemUsingSwipe: ( (Task?, @escaping (Bool?) -> Void ) -> Void )?
    var taskStateDidChange: ( (UUID) -> Void )?
    var taskNotificationDidChange: ( (Task?) -> Void )?
    
    var taskEditButtonDidTap: ( (Task) -> Void )?
    
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        register(TaskCellView.self, forCellReuseIdentifier: TaskCellView.cellIdentifier)
        
        delegate = self
        dataSource = self
        
        backgroundColor = nil
        scrollsToTop = false
        tableHeaderView = UIView()
        separatorStyle = .none
        allowsSelection = false
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let datum = tasks?[indexPath.row] else { return }
        
        if let cell = cell as? TaskCellView {
            cell.taskStateDidChange = { [weak self] newState in
                if let taskStateDidChange = self?.taskStateDidChange {
                    taskStateDidChange(datum.id)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = dequeueReusableCell(withIdentifier: TaskCellView.cellIdentifier) as? TaskCellView else {
            return UITableViewCell()
        }
        
        if let datum = tasks?[indexPath.row] {
            cell.id = datum.id
            cell.titleLabel?.text = datum.title
            cell.tagsCollectionView?.tags = String.split(datum.tags)
            cell.tagsCollectionView?.reloadData()
            cell.setTaskState(to: datum.isFinished)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TaskCellView {
            print("cell with id \(cell.id!.uuidString) returned to cell pool!")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    enum NotificationState: String {
        case pending = "bell.fill"
        case expired = "bell"
        case off = "bell.slash"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let datum = tasks?[indexPath.row] else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            
            if let deleteItemUsingSwipe = self?.deleteItemUsingSwipe {
                deleteItemUsingSwipe(datum) { [weak self] isSuccess in
                    if let isSuccess = isSuccess {
                        if isSuccess {
                            self?.tasks?.removeAll(where: { task in
                                task.id == datum.id
                            })
                            completion(isSuccess)
                        }
                    }
                }
            }
        }
        delete.image = UIImage(systemName: "trash")
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            
            if let taskEditButtonDidTap = self?.taskEditButtonDidTap {
                taskEditButtonDidTap(datum)
            }
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = .systemGray2
        
        
        
        
        let notification = UIContextualAction(style: .normal, title: "Notification") { [weak self] _, _, completion in
            
            if let taskNotificationDidChange = self?.taskNotificationDidChange {
                taskNotificationDidChange(datum)
            }
            
            return completion(true)
        }
        if datum.notification {
            if datum.deadline < Date() {
                notification.image = .init(systemName: NotificationState.expired.rawValue)
            } else {
                notification.image = .init(systemName: NotificationState.pending.rawValue)
            }
        } else {
            notification.image = .init(systemName: NotificationState.off.rawValue)
        }
        notification.backgroundColor = .systemGray3
        
        
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit, notification])
        return swipeActions
    }
    
    deinit {
        print("TaskTableView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
