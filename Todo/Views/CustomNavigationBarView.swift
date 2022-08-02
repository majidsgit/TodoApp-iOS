//
//  CustomNavigationBarView.swift
//  Todo
//
//  Created by developer on 7/29/22.
//

import UIKit

final class CustomNavigationBarView: UIView {
    
    var title: String? = nil
    var subtitle: String? = nil
    internal var hasBackButton: Bool? = nil
    internal var hasDateSelector: Bool? = nil
    
    var dismissButtonDidTap: ( () -> ()? )?
    var dateDidSelect: ( (Date) -> Void )? = nil
    
    lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .text
        return label
    }()
    
    lazy var subtitleLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .text
        return label
    }()
    
    @objc internal func backButtonDidTap() {
        // dismiss current view!
        if let dismissButtonTapped = dismissButtonDidTap {
            dismissButtonTapped()
        }
    }
    
    private lazy var backButton: UIImageView? = { [unowned self] in
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 32, height: 32))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .text
        
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backButtonDidTap))
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        
        return imageView
    }()
    
    private lazy var dateSelector: UIDatePicker? = {
        let picker = UIDatePicker()
        picker.date = .now
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.tintColor = .systemBlue
        
        picker.addAction(UIAction(handler: { [weak self] _ in
            if let dateDidSelect = self?.dateDidSelect {
                dateDidSelect(self?.dateSelector?.date ?? Date())
            }
        }), for: .valueChanged)
        
        return picker
    }()
    
    private func setupBackButton() {
        addSubview(backButton!)
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            backButton!.topAnchor.constraint(equalTo: self.topAnchor, constant: 48.0),
            backButton!.widthAnchor.constraint(equalToConstant: 32.0),
            backButton!.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    private func setupTitles() {
        
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel?.text = self.title
        subtitleLabel?.text = self.subtitle
        
        addSubview(titleLabel!)
        addSubview(subtitleLabel!)
        
        NSLayoutConstraint.activate([
            subtitleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            subtitleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel!.bottomAnchor.constraint(equalTo: subtitleLabel!.topAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
        ])
    }
    
    private func setupDateSelector() {
        addSubview(dateSelector!)
        dateSelector?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateSelector!.centerYAnchor.constraint(equalTo: titleLabel!.centerYAnchor),
            dateSelector!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),
            dateSelector!.widthAnchor.constraint(equalToConstant: 32.0),
            dateSelector!.heightAnchor.constraint(equalToConstant: 32.0),
        ])
        
        _ = dateSelector?.subviews.map { subview in
            subview.tintColor = .text
        }
        
        dateSelector?.backgroundColor = .text
        
        let image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 32.0, height: 32.0))
        imageView.image = image
        imageView.tintColor = .text
        
        dateSelector?.mask = imageView
        dateSelector?.layoutSubviews()
    }
    
    init(title: String? = nil, subtitle: String? = nil, hasBackButton: Bool? = false, hasDateSelector: Bool? = false) {
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150.0)
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        self.title = title
        self.subtitle = subtitle
        self.hasBackButton = hasBackButton
        self.hasDateSelector = hasDateSelector
        
        if let hasBackButton = hasBackButton {
            if hasBackButton {
                setupBackButton()
            } else {
                setupTitles()
            }
        }
        
        if let hasDateSelector = hasDateSelector {
            if hasDateSelector {
                setupDateSelector()
            }
        }
    }
    
    deinit {
        print("CustomNavigationBarView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
