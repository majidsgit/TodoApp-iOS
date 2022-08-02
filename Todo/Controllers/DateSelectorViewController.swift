//
//  DateSelectorViewController.swift
//  Todo
//
//  Created by developer on 7/29/22.
//

import UIKit

final class DateSelectorViewController: UIViewController {
    
    var selectedDate: Date? = Date()
    var dateDidSelect: ( (Date) -> Void )? = nil
    
    private lazy var datePickerView: CustomDatePickerView? = { [weak self] in
        let datePicker = CustomDatePickerView(date: self?.selectedDate)
        
        datePicker.valueChanged = { [weak self] newDate in
            if let dateDidSelect = self?.dateDidSelect, let newDate = newDate {
                dateDidSelect(newDate)
                self?.timePickerView?.date = newDate
            }
        }
        
        return datePicker
    }()
    
    private lazy var timePickerView: CustomDatePickerView? = { [weak self] in
        let timePicker = CustomDatePickerView(date: self?.selectedDate)
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        
        timePicker.valueChanged = { [weak self] newDate in
            if let dateDidSelect = self?.dateDidSelect, let newDate = newDate {
                dateDidSelect(newDate)
            }
        }
        
        return timePicker
    }()
    
    private lazy var timeLabelView: UILabel? = {
        let label = UILabel()
        label.text = "Time"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .text
        return label
    }()
    
    private lazy var timePickerAndLabelStackView: UIStackView? = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24.0
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .background
        
        view.addSubview(timePickerAndLabelStackView!)
        timePickerAndLabelStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabelView?.translatesAutoresizingMaskIntoConstraints = false
        timePickerView?.translatesAutoresizingMaskIntoConstraints = false
        
        timePickerAndLabelStackView?.addArrangedSubview(timeLabelView!)
        timePickerAndLabelStackView?.addArrangedSubview(timePickerView!)
        
        view.addSubview(datePickerView!)
        datePickerView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewSheet = sheetPresentationController {
            viewSheet.detents = [.medium(), .large()]
            viewSheet.sourceView?.frame = datePickerView!.frame
            viewSheet.prefersGrabberVisible = true
            
            viewSheet.prefersScrollingExpandsWhenScrolledToEdge = false
            viewSheet.prefersEdgeAttachedInCompactHeight = true
            viewSheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            datePickerView!.topAnchor.constraint(equalTo: view.topAnchor),
            datePickerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePickerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            timePickerAndLabelStackView!.topAnchor.constraint(equalTo: datePickerView!.bottomAnchor),
            timePickerAndLabelStackView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            timePickerAndLabelStackView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
        ])
    }
    
    init(initDate: Date?) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDate = initDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DateSelectorViewController deinited!")
    }
}
