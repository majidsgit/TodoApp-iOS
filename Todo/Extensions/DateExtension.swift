//
//  DateExtension.swift
//  Todo
//
//  Created by developer on 7/30/22.
//

import Foundation

extension Date {

    enum DateFormat: String {
        case ddMMMMYYYY = "dd MMMM yyyy"
        case full = "E, d MMM yyyy HH:mm:ss Z"
    }
    
    static func getTimeComponents(of date: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: calendar.timeZone, from: date)
        return components
    }
    
    static func getSummary(of date: Date) -> String {
        
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        return getStringDate(of: date, format: .ddMMMMYYYY)
    }
    
    static func getStringDate(of date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    static func getFirstTime(of date: Date) -> Date {
        if let newDate = Calendar.current.date(bySettingHour: 00, minute: 00, second: 01, of: date, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) {
            return newDate
        }
        return date
    }
    
    static func getLastTime(of date: Date) -> Date {
        if let newDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) {
            return newDate
        }
        return date
    }
}
