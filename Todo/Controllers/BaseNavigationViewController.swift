//
//  BaseNavigationViewController.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit
import CoreData

final class BaseNavigationViewController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    var persistentContainer: NSPersistentContainer?
    
    init(persistentContainer: NSPersistentContainer) {
        
        UNUserNotificationCenter.removeAllNotifications()
        
        let rootViewController = TasksViewController()
        rootViewController.persistentContainer = persistentContainer
        
        super.init(rootViewController: rootViewController)
        
        self.persistentContainer = persistentContainer
        
        navigationBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
