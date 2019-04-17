//
//  ItemCollectionViewCell.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/17.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        
        let view = UILabel()
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var spLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        customSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func customSubviews(){
        
        backgroundColor = UIColor.white
        
        contentView.addSubview(spLine)
        spLine.translatesAutoresizingMaskIntoConstraints = false
        spLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        spLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        spLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        spLine.heightAnchor.constraint(equalToConstant: 0.5)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
