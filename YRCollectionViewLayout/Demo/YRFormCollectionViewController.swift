//
//  YRFormCollectionViewController.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/18.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YRFormCollectionViewController: NormalCollectionViewController {

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
            ) as! YRFormCollectionViewController.ItemCell
        
        
        if indexPath.section % 2 == 0 {
            cell.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        }else{
            cell.backgroundColor = UIColor.init(white: 0.4, alpha: 1)
        }
        
        cell.titleLabel.text = "\(indexPath.section)-\(indexPath.item)"
        
        return cell
    }
}


extension YRFormCollectionViewController:YRFormDelegateFlowLayout {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 30)
    }
    
}

//MARK: - --------------Model--------------

extension YRFormCollectionViewController {
    
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
            
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        }
    }
}
