//
//  CustomDatePickerView.swift
//  Todo
//
//  Created by developer on 7/29/22.
//

import UIKit

class CustomDatePickerView: UIDatePicker {
    
    var valueChanged: ( (Date?) -> Void )?
    
    init(date: Date? = nil) {
        super.init(frame: .zero)
        
        preferredDatePickerStyle = .inline
        datePickerMode = .date
        
        roundsToMinuteInterval = true
        locale = .autoupdatingCurrent
        timeZone = .autoupdatingCurrent
        
        if let date = date {
            self.date = date
        }
        
        self.date = date ?? Date()
        self.minimumDate = Date()
        
        addAction(UIAction(handler: { [weak self] _ in
            
            if let valueChanged = self?.valueChanged {
                valueChanged(self?.date)
            }
            
        }), for: .valueChanged)
        
    }
    
    deinit {
        print("CustomDatePickerView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
