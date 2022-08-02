//
//  TasksViewController.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit
import CoreData

final class TasksViewController: UIViewController {
    
    lazy var date: Date? = .now
    lazy var persistentContainer: NSPersistentContainer? = nil
    
    lazy var customNavigationView: CustomNavigationBarView? = { [weak self] in
        let navigation = CustomNavigationBarView(hasDateSelector: true)
        navigation.dateDidSelect = { [weak self] newDate in
            self?.date = newDate
            self?.loadData()
        }
        return navigation
    }()
    
    lazy var tableView: TaskTableView? = {
        let tableView = TaskTableView()
        
        tableView.deleteItemUsingSwipe = { [weak self] taskToDelete, completion in
            guard let taskToDelete = taskToDelete else { return }
            CoreDataController.remove(task: taskToDelete, using: self?.persistentContainer) { isDeleted in
                completion(isDeleted)
            }
        }
        
        tableView.taskStateDidChange = { [weak self] taskId in
            
            CoreDataController.updateTaskState(with: taskId, using: self?.persistentContainer) { isUpdated in
                
                if isUpdated {
                    self?.loadData()
                }
            }
        }
        
        tableView.taskNotificationDidChange = { [weak self] taskItem in
            CoreDataController.updateTaskNotificationState(of: taskItem, using: self?.persistentContainer) { isUpdated in
                self?.loadData()
            }
        }
        
        tableView.taskEditButtonDidTap = { [weak self] toEditTask in
            
            let editTaskViewController = EditTaskViewController(editingTask: toEditTask)
            editTaskViewController.persistentContainer = self?.persistentContainer
            self?.show(editTaskViewController, sender: self)
        }
        
        return tableView
    }()
    
    lazy var addFloatingButton: CustomFloatingButtonView? = {
        let button = CustomFloatingButtonView(image: .plusButtonImage) { [weak self] in
            let newVC = AddTaskViewController()
            newVC.persistentContainer = self?.persistentContainer
            self?.show(newVC, sender: self)
        }
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tableView?.tasks = nil
    }
    
    deinit {
        print("TasksViewController deinited!")
    }
}



// MARK: - View Functionalities
extension TasksViewController {
    
    override func loadView() {
        let view = UIView()
        
        view.backgroundColor = .background

        view.addSubview(customNavigationView!)
        customNavigationView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView!)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addFloatingButton!)
        addFloatingButton?.translatesAutoresizingMaskIntoConstraints = false

        self.view = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonHeight = 56.0
        NSLayoutConstraint.activate([
            customNavigationView!.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationView!.heightAnchor.constraint(equalToConstant: 150.0),
            customNavigationView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            tableView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView!.topAnchor.constraint(equalTo: customNavigationView!.bottomAnchor, constant: 32.0),

            addFloatingButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            addFloatingButton!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24.0),
            addFloatingButton!.widthAnchor.constraint(equalToConstant: buttonHeight),
            addFloatingButton!.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
}



// MARK: - Data Functionalities
extension TasksViewController {
    
    private func setupDateAndTaskCount(date: Date, count: Int) {
        customNavigationView?.titleLabel?.text = Date.getStringDate(of: date, format: .ddMMMMYYYY)
        if count == 0 {
            customNavigationView?.subtitleLabel?.text = String("No Task")
            return
        } else {
            customNavigationView?.subtitleLabel?.text = String("\(count) \(count == 1 ? "Task" : "Tasks")")
        }
    }
    
    private func loadData() {
        
        guard let date = date else { return }
        
        CoreDataController.fetchItems(of: date, using: persistentContainer) { [weak self] tasks in
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.tasks = tasks
                self?.tableView?.reloadData()
                self?.setupDateAndTaskCount(date: self?.date ?? .now, count: tasks?.count ?? 0)
            }
        }
    }
}
