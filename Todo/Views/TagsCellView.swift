//
//  TagsCellView.swift
//  Todo
//
//  Created by developer on 7/31/22.
//

import UIKit

class TagsCellView: UICollectionViewCell {
    
    static let cellIdentifier = "tag"
    var title: String? = nil
    
    lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .textYellow
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        automaticallyUpdatesContentConfiguration = true
        
        addSubview(titleLabel!)
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel!.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel!.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            leadingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -8.0),
            trailingAnchor.constraint(equalTo: titleLabel!.trailingAnchor, constant: 8.0),
            topAnchor.constraint(equalTo: titleLabel!.topAnchor, constant: -4.0),
            bottomAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 4.0),
        ])
        
        
        backgroundColor = .radioBorder
        layer.cornerRadius = 4.0
    }
    
    deinit {
        print("TagsCellView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
