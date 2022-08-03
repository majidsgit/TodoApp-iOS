//
//  UNNotificationCenterExtension.swift
//  Todo
//
//  Created by developer on 8/1/22.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    
    static func isNotificationAccessGranted(completion: @escaping (Bool) -> Void) {
        let currentCenter = UNUserNotificationCenter.current()
        currentCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.askForNotificationAccess { isGranted in
                    completion(isGranted)
                }
            case .denied:
                completion(false)
            case .authorized, .provisional, .ephemeral:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
    
    static func askForNotificationAccess(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                completion(granted)
            }
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func removeNotification(with id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    static func getAllNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification.description)
            }
        }
    }
    
    static func removeAllNotifications(removePendings: Bool = false) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        if removePendings {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    static func addNotification(item: Task?) {
        
        guard let item = item else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "new task: " + item.title
        content.subtitle = "new task is waiting... " + item.tags
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification.mp3"))
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second, .day, .month, .year, .calendar], from: item.deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.isNotificationAccessGranted { isGranted in
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("new notification added!")
                }
            }
        }
    }
}
