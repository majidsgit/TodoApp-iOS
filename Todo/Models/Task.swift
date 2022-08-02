//
//  Task.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import Foundation
import CoreData

struct Task: Codable, Identifiable {
    let id: UUID
    var title: String
    var tags: String
    var deadline: Date
    var notification: Bool
    var isFinished: Bool
    
    init(data: Entity) {
        self.id = data.identifier ?? UUID()
        self.title = data.title ?? ""
        self.tags = data.tags ?? ""
        self.deadline = data.deadline ?? .now
        self.notification = data.notification
        self.isFinished = data.isFinished
    }
    
    init() {
        self.id = UUID()
        self.title = ""
        self.tags = ""
        self.deadline = .now
        self.notification = true
        self.isFinished = false
    }
    
    mutating func changeFinishState(with newState: Bool) {
        self.isFinished = newState
    }
    
    mutating func changeTitle(with newTitle: String) {
        self.title = newTitle
    }
    
    mutating func changeTags(with newTags: String) {
        self.tags = newTags
    }
    
    mutating func changeDeadLine(with newDeadLine: Date) {
        self.deadline = newDeadLine
        print(deadline)
    }
    
    mutating func changeNotification(with newState: Bool) {
        print("notification switch currently is", newState ? "on" : "off")
        self.notification = newState
    }
}
