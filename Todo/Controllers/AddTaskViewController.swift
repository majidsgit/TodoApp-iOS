//
//  AddTaskViewController.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit
import CoreData

final class AddTaskViewController: UIViewController {
    
    private var date: Date? = Date()
    private var newTask: Task = Task()
    lazy var persistentContainer: NSPersistentContainer? = nil
    
    lazy var customNavigationView: CustomNavigationBarView? = {
        let navigation = CustomNavigationBarView(hasBackButton: true)
        navigation.dismissButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return navigation
    }()
    
    lazy var todoTitleView: TodoTitleView? = {
        let title = TodoTitleView(content: nil)
        title.textFieldDidUpdate = { [weak self] newText in
            if let newText = newText {
                self?.newTask.changeTitle(with: newText)
            }
        }
        return title
    }()
    
    lazy var todoTagsView: TodoTagsView? = {
        let tags = TodoTagsView(initTagString: nil)
        
        return tags
    }()
    
    lazy var todoDateAndNotificationView: TodoDateAndNotificationView? = { [weak self] in
        let date = TodoDateAndNotificationView(initDate: self?.date)
        
        date.onTap = { [weak self] in
            let dateSelectorVC = DateSelectorViewController(initDate: self?.date)
            
            dateSelectorVC.dateDidSelect = { [weak self] newdate in
                self?.todoDateAndNotificationView?.dateLabel?.text = Date.getSummary(of: newdate)
                self?.date = newdate
                self?.newTask.changeDeadLine(with: newdate)
            }
            
            self?.present(dateSelectorVC, animated: true)
        }
        
        date.onSwitchValueChange = { [weak self] notificationStatus in
            self?.newTask.changeNotification(with: notificationStatus)
        }
        
        return date
    }()
    
    lazy var addFloatingButton: CustomFloatingButtonView? = {
        let button = CustomFloatingButtonView(image: .checkButtonImage) { [weak self] in
            
            CoreDataController.add(new: self?.newTask, with: self?.todoTagsView?.tags, using: self?.persistentContainer) { [weak self] isAdded in
                if isAdded {
                    if let isNotificationAvailable = self?.newTask.notification {
                        if isNotificationAvailable {
                            UNUserNotificationCenter.addNotification(item: self?.newTask)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        return button
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .background
        
        view.addSubview(customNavigationView!)
        customNavigationView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(todoTitleView!)
        todoTitleView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(todoTagsView!)
        todoTagsView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(todoDateAndNotificationView!)
        todoDateAndNotificationView?.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(addFloatingButton!, aboveSubview: customNavigationView!)
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
            customNavigationView!.widthAnchor.constraint(equalTo: view.widthAnchor),
            customNavigationView!.heightAnchor.constraint(equalToConstant: 150.0),
            
            todoTitleView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            todoTitleView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            todoTitleView!.topAnchor.constraint(equalTo: customNavigationView!.bottomAnchor, constant: 0.0),
            
            todoTagsView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            todoTagsView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            todoTagsView!.topAnchor.constraint(equalTo: todoTitleView!.bottomAnchor, constant: 12.0),
            
            todoDateAndNotificationView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            todoDateAndNotificationView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            todoDateAndNotificationView!.topAnchor.constraint(equalTo: todoTagsView!.bottomAnchor, constant: 12.0),
            
            addFloatingButton!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            addFloatingButton!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24.0),
            addFloatingButton!.widthAnchor.constraint(equalToConstant: buttonHeight),
            addFloatingButton!.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    deinit {
        print("AddTaskViewController deinited!")
    }
}
