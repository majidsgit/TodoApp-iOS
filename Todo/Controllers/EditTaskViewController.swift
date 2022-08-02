//
//  EditTaskViewController.swift
//  Todo
//
//  Created by developer on 8/2/22.
//

import UIKit
import CoreData

final class EditTaskViewController: UIViewController {
    
    private var date: Date? = Date()
    private var editingTask: Task?
    lazy var persistentContainer: NSPersistentContainer? = nil
    
    lazy var customNavigationView: CustomNavigationBarView? = {
        let navigation = CustomNavigationBarView(hasBackButton: true)
        navigation.dismissButtonDidTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return navigation
    }()
    
    lazy var todoTitleView: TodoTitleView? = {
        let title = TodoTitleView(content: self.editingTask?.title)
        title.textFieldDidUpdate = { [weak self] newText in
            if let newText = newText {
                self?.editingTask?.changeTitle(with: newText)
            }
        }
        return title
    }()
    
    lazy var todoTagsView: TodoTagsView? = {
        let tagsView = TodoTagsView(initTagString: self.editingTask?.tags)
        
        tagsView.tagItemHoldDidOccur = { [weak self] tagIndex, tagValue in
            self?.todoTagsView?.tags?.remove(at: tagIndex)
            self?.editingTask?.changeTags(with: String.combine(self?.todoTagsView?.tags ?? []))
        }
        
        return tagsView
    }()
    
    lazy var todoDateAndNotificationView: TodoDateAndNotificationView? = { [weak self] in
        let date = TodoDateAndNotificationView(initDate: self?.date, initSwitchValue: self?.editingTask?.notification)
        
        date.onTap = { [weak self] in
            let dateSelectorVC = DateSelectorViewController(initDate: self?.editingTask?.deadline)
            
            dateSelectorVC.dateDidSelect = { [weak self] newdate in
                self?.todoDateAndNotificationView?.dateLabel?.text = Date.getSummary(of: newdate)
                self?.date = newdate
                self?.editingTask?.changeDeadLine(with: newdate)
            }
            
            self?.present(dateSelectorVC, animated: true)
        }
        
        date.onSwitchValueChange = { [weak self] notificationStatus in
            self?.editingTask?.changeNotification(with: notificationStatus)
        }
        
        return date
    }()
    
    lazy var addFloatingButton: CustomFloatingButtonView? = {
        let button = CustomFloatingButtonView(image: .checkButtonImage) { [weak self] in
            
            guard let tags = self?.todoTagsView?.tags else { return }
            
            guard tags.count > 0 else { return }
            
            self?.editingTask?.changeTags(with: String.combine(tags))
            
            if self?.editingTask?.tags != "" {
                CoreDataController.updateTask(with: self?.editingTask, using: self?.persistentContainer) { [weak self] isUpdated in
                    
                    if isUpdated {
                        self?.navigationController?.popViewController(animated: true)
                    }
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
        todoTagsView?.reloadTags(with: editingTask?.tags)
        
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
    
    init(editingTask: Task) {
        super.init(nibName: nil, bundle: nil)
        
        self.editingTask = editingTask
        self.date = editingTask.deadline
    }
    
    deinit {
        print("AddTaskViewController deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

