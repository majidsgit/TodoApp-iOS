//
//  TodoDateAndNotificationView.swift
//  Todo
//
//  Created by developer on 7/30/22.
//

import UIKit

class TodoDateAndNotificationView: UIView {
    
    var onTap: ( () -> Void )?
    var onSwitchValueChange: ( (Bool) -> Void )?
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.textColor = .textYellow
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var dateLabel: UILabel? = {
        let label = UILabel()
        label.textColor = .text
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var notificationSwitch: UISwitch? = {
        let notificationSwitch = UISwitch()
        notificationSwitch.isOn = true
        notificationSwitch.onTintColor = .textYellow
        notificationSwitch.preferredStyle = .sliding
        notificationSwitch.addAction(UIAction(handler: { [weak self] _ in
            if let onSwitchValueChange = self?.onSwitchValueChange {
                onSwitchValueChange(notificationSwitch.isOn)
            }
        }), for: .valueChanged)
        return notificationSwitch
    }()
    
    init(initDate: Date?, initSwitchValue: Bool?) {
        super.init(frame: .zero)
        
        addSubview(titleLabel!)
        titleLabel?.text = "Deadline"
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel!)
        dateLabel?.text = Date.getSummary(of: initDate ?? Date())
        dateLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(notificationSwitch!)
        notificationSwitch?.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch?.isOn = initSwitchValue ?? true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tapGesture.numberOfTapsRequired = 1
        
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewDidTap() {
        if let onTap = onTap {
            onTap()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: topAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            dateLabel!.topAnchor.constraint(greaterThanOrEqualTo: titleLabel!.bottomAnchor),
            dateLabel!.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel!.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel!.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            notificationSwitch!.trailingAnchor.constraint(equalTo: trailingAnchor),
            notificationSwitch!.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    deinit {
        print("TodoDateAndNotificationView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
