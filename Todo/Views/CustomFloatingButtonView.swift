//
//  CustomFloatingButtonView.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit

class CustomFloatingButtonView: UIButton {
    
    var image: UIImage?
    private var buttonDidTap: (() -> ()?)?
    
    var customImageView = UIImageView()
    
    init(image: UIImage?, onTap: @escaping (()->Void)) {
        super.init(frame: .zero)
        frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = frame.height / 2
        
        self.image = image
        self.buttonDidTap = onTap
        
        customImageView.image = image?.withRenderingMode(.alwaysTemplate)
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.tintColor = .floatingForeground
        
        addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            customImageView.widthAnchor.constraint(equalToConstant: 32.0),
            customImageView.heightAnchor.constraint(equalToConstant: 32.0),
            customImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        addAction(action, for: .touchUpInside)
        backgroundColor = .floatingBackground
    }
    
    lazy var action: UIAction = {
        UIAction { [weak self] _ in
            if let buttonDidTap = self?.buttonDidTap {
                buttonDidTap()
            }
        }
    }()
    
    deinit {
        print("CustomFloatingButtonView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
