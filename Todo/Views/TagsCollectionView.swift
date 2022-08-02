//
//  TagsCollectionView.swift
//  Todo
//
//  Created by developer on 7/31/22.
//

import UIKit

class TagsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var tags: [String] = []
    
    var tagItemHoldDidOccur: ( (Int, String) -> Void )?
    
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.sectionInsetReference = .fromContentInset
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        collectionViewLayout = layout
        
        register(TagsCellView.self, forCellWithReuseIdentifier: TagsCellView.cellIdentifier)
        
        delegate = self
        dataSource = self
        
        backgroundColor = nil
        scrollsToTop = false
        allowsSelection = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TagsCellView {
            
            return cell.intrinsicContentSize
        }
        
        return CGSize(width: 100, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        if let tagItemHoldDidOccur = tagItemHoldDidOccur {
            tagItemHoldDidOccur(indexPath.row, tags[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: TagsCellView.cellIdentifier, for: indexPath) as? TagsCellView else {
            return UICollectionViewCell()
        }
        let datum = tags[indexPath.row] 
        cell.titleLabel?.text = "#\(datum)"
        return cell
    }
    
    deinit {
        print("TagsCollectionView deinited!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
