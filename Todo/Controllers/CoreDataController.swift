//
//  CoreDataExtension.swift
//  Todo
//
//  Created by developer on 8/1/22.
//

import CoreData
import UserNotifications

final class CoreDataController {
    
    
    
    
    
    
    
    
    static func updateTaskState(with task: Task?, using container: NSPersistentContainer?, completion: @escaping (Bool) -> Void) {
        
        guard let context = container?.viewContext, let task = task else {
            fatalError("error loading persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        let findByIdPredicate = NSPredicate(format: "%K == %@", #keyPath(Entity.identifier), task.id as CVarArg)
        fetchRequest.predicate = findByIdPredicate
        
        guard let result = try? context.fetch(fetchRequest) as [NSManagedObject] else {
            return completion(false)
        }
        
        if let first = result.first {
            
            guard let lastFinishState = first.value(forKey: "isFinished") as? Int else {
                return completion(false)
            }
            
            first.setValue(lastFinishState == 0 ? 1 : 0, forKey: "isFinished")
            
            do {
                
                if lastFinishState == 0 {
                    UNUserNotificationCenter.removeNotification(with: task.id)
                    first.setValue(0, forKey: "notification")
                } else {
                    if task.deadline >= Date() {
                        UNUserNotificationCenter.addNotification(item: task)
                        first.setValue(1, forKey: "notification")
                    }
                }
                
                try context.save()
                
                return completion(true)
            } catch let error {
                print(error.localizedDescription)
                return completion(false)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    static func remove(task: Task, using container: NSPersistentContainer?, completion: @escaping (Bool?) -> Void ) {
        guard let context = container?.viewContext else {
            fatalError("error loading persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        let findByIdPredicate = NSPredicate(format: "%K == %@", #keyPath(Entity.identifier), task.id as CVarArg)
        fetchRequest.predicate = findByIdPredicate
        
        guard let result = try? context.fetch(fetchRequest) as [NSManagedObject] else {
            return completion(false)
        }
        
        if let first = result.first {
            context.delete(first)
            try? context.save()
            UNUserNotificationCenter.removeNotification(with: task.id)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    static func fetchItems(of date: Date?, using container: NSPersistentContainer?, completion: @escaping ([Task]?) -> Void) {
        
        guard let context = container?.viewContext else {
            fatalError("error loading persistent container.")
        }
        
        guard let date = date else {
            return completion(nil)
        }
        
        let firstTimeOfDate = Date.getFirstTime(of: date)
        let lastTimeOfDate = Date.getLastTime(of: date)
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        let firstPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entity.deadline), firstTimeOfDate as CVarArg)
        let lastPredicate = NSPredicate(format: "%K <= %@", #keyPath(Entity.deadline), lastTimeOfDate as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, lastPredicate])
        
        let sortByToday = NSSortDescriptor(key: "deadline", ascending: true)
        fetchRequest.sortDescriptors = [sortByToday]
        
        guard let result = try? context.fetch(fetchRequest) else {
            return completion(nil)
        }
        
        let tasks = result.compactMap { taskItem in
            return Task(data: taskItem)
        }
        
        completion(tasks)
    }
    
    
    
    
    
    
    
    
    
    
    static func add(new task: Task?, with tags: [String]?, using container: NSPersistentContainer?, completion: @escaping (Bool) -> Void) {
        
        // save data!
        guard let context = container?.viewContext else {
            fatalError("error loading persistent container.")
        }
        let newTaskItem = Entity(context: context)
        
        var stringTag = ""
        if let tags = tags {
            if tags.isNotEmpty() {
                stringTag = String.combine(tags)
            }
        }
        
        guard task?.title != "" && stringTag != "" && task?.deadline != nil else {
            return completion(false)
        }
        
        newTaskItem.identifier = task?.id
        newTaskItem.title = task?.title
        newTaskItem.tags = stringTag
        newTaskItem.deadline = task?.deadline
        newTaskItem.notification = task?.notification ?? false
        newTaskItem.isFinished = task?.isFinished ?? false
        
        do {
            try context.save()
            return completion(true)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    
    
    
    static func updateTaskNotificationState(of task: Task?, using container: NSPersistentContainer?, completion: @escaping (Bool) -> Void) {
        
        guard let context = container?.viewContext, let task = task else {
            fatalError("error loading persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        let findByIdPredicate = NSPredicate(format: "%K == %@", #keyPath(Entity.identifier), task.id as CVarArg)
        fetchRequest.predicate = findByIdPredicate
        
        guard let result = try? context.fetch(fetchRequest) as [NSManagedObject] else {
            return completion(false)
        }
        if let first = result.first {
            
            guard let notificationPreviousState = first.value(forKey: "notification") as? Bool else {
                return completion(false)
            }
            
            first.setValue(notificationPreviousState == false ? 1 : 0, forKey: "notification")
            do {
                try context.save()
                
                if task.notification {
                    if task.deadline >= Date() {
                        UNUserNotificationCenter.addNotification(item: task)
                    } else {
                        UNUserNotificationCenter.removeNotification(with: task.id)
                    }
                } else {
                    UNUserNotificationCenter.removeNotification(with: task.id)
                }
                
                return completion(true)
            } catch let error {
                print(error.localizedDescription)
                return completion(false)
            }
        }
    }
    
    static func updateTask(with newTask: Task?, using container: NSPersistentContainer?, completion: @escaping (Bool) -> Void) {
        
        guard let context = container?.viewContext, let task = newTask else {
            fatalError("error loading persistent container.")
        }
        
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        let findByIdPredicate = NSPredicate(format: "%K == %@", #keyPath(Entity.identifier), task.id as CVarArg)
        fetchRequest.predicate = findByIdPredicate
        
        guard let result = try? context.fetch(fetchRequest) as [NSManagedObject] else {
            return completion(false)
        }
        
        if let first = result.first {
            
            guard let notificationPreviousState = first.value(forKey: "notification") as? Bool else {
                return completion(false)
            }
            
            let isNotificationChanged = notificationPreviousState != task.notification
            
            guard let datePreviousValue = first.value(forKey: "deadline") as? Date else {
                return completion(false)
            }
            
            let dateChanged = datePreviousValue != task.deadline
            
            first.setValue(task.deadline, forKey: "deadline")
            first.setValue(task.notification ? 1 : 0, forKey: "notification")
            first.setValue(task.isFinished ? 1 : 0, forKey: "isFinished")
            first.setValue(task.tags, forKey: "tags")
            first.setValue(task.title, forKey: "title")
            
            do {
                try context.save()
                if isNotificationChanged{
                    if notificationPreviousState == true && !dateChanged  {
                        UNUserNotificationCenter.removeNotification(with: task.id)
                    } else {
                        if task.deadline >= Date() {
                            UNUserNotificationCenter.addNotification(item: task)
                        }
                    }
                } else {
                    if task.deadline >= Date() {
                        UNUserNotificationCenter.addNotification(item: task)
                    }
                }
                return completion(true)
            } catch let error {
                print(error.localizedDescription)
                return completion(false)
            }
        }
        
    }
}
