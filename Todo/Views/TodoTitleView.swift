//
//  TodoTitleView.swift
//  Todo
//
//  Created by developer on 7/30/22.
//

import UIKit

class TodoTitleView: UIView, UITextFieldDelegate {
    
    var content: String? = nil
    var textFieldDidUpdate: ( (String?) -> Void )? = nil
    
    private let placeholderText = [
        "Wake up at the same time every day",
        "Make your bed",
        "Meditate",
        "Exercise",
        "Take a shower",
        "Eat breakfast",
        "Drink a glass of water",
        "Take vitamins",
        "Review your to-do list for the day",
        "Check your email at the same time every day",
        "Make Lunch",
        "Stretch",
        "Schedule in short breaks",
        "Do a hobby you love",
        "Do one thing that intimidates you",
        "Commit to time for honing a skill",
        "Straighten up your workspace",
        "Have at least one real conversation",
        "Read",
        "Write down three good things that happened that day",
        "Lay out your clothes for the next day before bed",
        "Go to bed at the same time every day"
    ]
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.textColor = .textYellow
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var textField: UITextField? = { [weak self] in
        let textField = UITextField()
        textField.delegate = self
        textField.enablesReturnKeyAutomatically = false
        textField.returnKeyType = .done
        textField.showsLargeContentViewer = false
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.tintColor = .text
        textField.textColor = .text
        textField.font = .systemFont(ofSize: 24, weight: .bold)
        return textField
    }()
    
    init(content: String?) {
        super.init(frame: .zero)
        
        self.content = content
        
        addSubview(titleLabel!)
        titleLabel?.text = "To-do"
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField!)
        if let content = content {
            textField?.text = content
        } else {
            textField?.placeholder = placeholderText.randomElement()
        }
        textField?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: topAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            textField!.topAnchor.constraint(greaterThanOrEqualTo: titleLabel!.bottomAnchor),
            textField!.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField!.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldDidUpdate = textFieldDidUpdate {
            textFieldDidUpdate(textField.text)
        }
    }
    
    deinit {
        print("TodoTitleView deinited!")
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
