//
//  TodoTagsView.swift
//  Todo
//
//  Created by developer on 7/31/22.
//

import UIKit

class TodoTagsView: UIView, UITextFieldDelegate {
    
    var initTagString: String? = nil
    var tags: [String]? = [] {
        didSet {
            // update
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 1.0, delay: 0, options: .beginFromCurrentState) {
                    self?.collectionView?.tags = self?.tags ?? []
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
    
    var tagItemHoldDidOccur: ( (Int, String) -> Void )?
    
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
        textField.font = .systemFont(ofSize: 18, weight: .bold)
        return textField
    }()
    
    private lazy var collectionView: TagsCollectionView? = {
        let collection = TagsCollectionView()
        
        collection.tagItemHoldDidOccur = { [weak self] tagIndex, tagValue in
            if let tagItemHoldDidOccur = self?.tagItemHoldDidOccur {
                tagItemHoldDidOccur(tagIndex, tagValue)
            }
        }
        
        return collection
    }()
    
    func reloadTags(with tagString: String?) {
        if let tagString = tagString {
            self.tags = String.split(tagString)
        }
    }
    
    init(initTagString: String?) {
        super.init(frame: .zero)
        
        self.initTagString = initTagString
        if let initTagString = initTagString {
            self.tags = String.split(initTagString)
        }
        
        addSubview(titleLabel!)
        titleLabel?.text = "Tags"
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField!)
        textField?.placeholder = "separate tags by ,"
        textField?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView!)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: topAnchor),
            titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            textField!.topAnchor.constraint(greaterThanOrEqualTo: titleLabel!.bottomAnchor),
            textField!.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField!.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView!.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView!.topAnchor.constraint(equalTo: textField!.bottomAnchor),
            collectionView!.heightAnchor.constraint(equalToConstant: 32),
            
            textField!.bottomAnchor.constraint(equalTo: collectionView!.topAnchor),
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "", string == "," {
            if let tag = String.split(textField.text!).first {
                if tag == "" {
                    return true
                }
                tags?.append(tag)
                textField.text = ""
                return false
            }
        }
        return true
    }
    
    deinit {
        print("TodoTagsView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
