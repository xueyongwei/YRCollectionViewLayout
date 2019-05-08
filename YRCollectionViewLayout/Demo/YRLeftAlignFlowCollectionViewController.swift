//
//  YRLeftAlignFlowCollectionViewController.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/5/8.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YRLeftAlignFlowCollectionViewController: NormalCollectionViewController {
    
    var text:[String] = [
        "似懂非懂",
        "2个",
        "你说的都对只是不明白",
        "只是不明白",
        "为什么会是两个？",
        "只是不明白为什么会是两个",
        "2个",
        "为什么会是两个？",
        "似懂非懂",
        "2个只是不明白为什么",
        "你说的都对",
        "只是不明白",
        "为什么会是两个？"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.isDirectionalLockEnabled = true
        self.collectionView!.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 50
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
            ) as! YRLeftAlignFlowCollectionViewController.ItemCell
        
        
        let salt = text[indexPath.item]
        cell.titleLabel.text = "\(indexPath.section)-\(salt)-\(indexPath.item)"
        
        return cell
    }
}


extension YRLeftAlignFlowCollectionViewController {
    
//    func sizeForItem(at indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: 60, height: 30)
//    }
    
}

//MARK: - --------------Model--------------

extension YRLeftAlignFlowCollectionViewController {
    
    class ItemCell:UICollectionViewCell {
        
        lazy var titleLabel: UILabel = {
            
            let view = UILabel()
            view.textColor = UIColor.black
            view.font = UIFont.systemFont(ofSize: 15)
            view.textAlignment = .center
            return view
        }()
        
        override init(frame: CGRect) {
            
            super.init(frame: frame)
            customSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            
            super.init(coder: aDecoder)
            customSubviews()
        }
        
        func customSubviews(){
            
            contentView.backgroundColor = UIColor.lightGray
            contentView.layer.cornerRadius = 15
            contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
            titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
}
