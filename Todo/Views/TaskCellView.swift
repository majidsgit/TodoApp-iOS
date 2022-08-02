//
//  TaskCellView.swift
//  Todo
//
//  Created by developer on 7/27/22.
//

import UIKit

class TaskCellView: UITableViewCell {
    
    static let cellIdentifier = "task"
    
    var id: UUID? = nil
    var taskStateDidChange: ( (Bool) -> Void )?
    
    lazy var sideCircle: UIView? = {
        let circle = UIView()
        circle.backgroundColor = .background
        circle.layer.borderWidth = 2.0
        circle.layer.borderColor = UIColor.radioBorder?.cgColor
        
        
        circle.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sideCircleViewDidTap))
        gesture.numberOfTapsRequired = 1
        circle.addGestureRecognizer(gesture)
        
        return circle
    }()
    
    @objc private func sideCircleViewDidTap() {
        if let taskStateDidChange = taskStateDidChange {
            DispatchQueue.main.async { [weak self] in
                if let state = self?.finishCircleView?.isHidden {
                    taskStateDidChange(!state)
                    self?.finishCircleView?.isHidden = !state
                }
            }
        }
    }
    
    lazy var finishCircleView: UIView? = {
        let circle = UIView()
        circle.backgroundColor = .textYellow
        
        circle.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sideCircleViewDidTap))
        gesture.numberOfTapsRequired = 1
        circle.addGestureRecognizer(gesture)
        
        return circle
    }()
    
    lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .text
        return label
    }()
    
    lazy var tagsCollectionView: TagsCollectionView? = {
        let collection = TagsCollectionView()
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    func setTaskState(to isDone: Bool) {
        
        self.finishCircleView?.isHidden = !isDone
        if isDone {
            
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.textYellow ?? .clear, range: NSRange(location: 0, length: attributeString.length))
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .regular), range: NSRange(location: 0, length: attributeString.length))
            self.titleLabel?.attributedText = attributeString
            self.titleLabel?.textColor = .radioBorder
            
            self.tagsCollectionView?.layer.opacity = 0.3
            
        } else {
            
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: attributeString.length))
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .regular), range: NSRange(location: 0, length: attributeString.length))
            self.titleLabel?.attributedText = attributeString
            self.titleLabel?.textColor = .radioBorder
            self.titleLabel?.textColor = .text
            
            self.tagsCollectionView?.layer.opacity = 1.0
            
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubview(sideCircle!)
        sideCircle?.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.insertSubview(finishCircleView!, aboveSubview: sideCircle!)
        finishCircleView?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel!)
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tagsCollectionView!)
        tagsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sideCircle!.centerYAnchor.constraint(equalTo: centerYAnchor),
            sideCircle!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            sideCircle!.widthAnchor.constraint(equalToConstant: 38.0),
            sideCircle!.heightAnchor.constraint(equalToConstant: 38.0),
            
            finishCircleView!.widthAnchor.constraint(equalToConstant: 30.0),
            finishCircleView!.heightAnchor.constraint(equalToConstant: 30.0),
            finishCircleView!.centerYAnchor.constraint(equalTo: sideCircle!.centerYAnchor),
            finishCircleView!.centerXAnchor.constraint(equalTo: sideCircle!.centerXAnchor),
            
            titleLabel!.leadingAnchor.constraint(equalTo: sideCircle!.trailingAnchor, constant: 16.0),
            titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            titleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),
            
            tagsCollectionView!.leadingAnchor.constraint(equalTo: sideCircle!.trailingAnchor, constant: 16.0),
            tagsCollectionView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),
            tagsCollectionView!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 6.0),
            tagsCollectionView!.heightAnchor.constraint(equalToConstant: 32),
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sideCircle?.layer.cornerRadius = sideCircle!.frame.height / 2
        finishCircleView?.layer.cornerRadius = finishCircleView!.frame.height / 2
    }
    
    deinit {
        print("TaskCellView deinited!")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
