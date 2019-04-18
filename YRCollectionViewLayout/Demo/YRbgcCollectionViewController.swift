//
//  YRbgcCollectionViewController.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/17.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit


class YRbgcCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.cellReuseIndentifier)
        collectionView.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        
    }

    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 10
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ItemCollectionViewCell.getCell(in: collectionView, at: indexPath)
    
        return cell
    }


}

extension YRbgcCollectionViewController:YRSectionBgColorDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sectionCornerRadiusFor section: Int) -> CGFloat {
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        
        if section%2 == 0 {
            return UIColor.red
        }else{
            return UIColor.green
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, edgeInsetExtendedFor section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    
}

extension ItemCollectionViewCell {
    
    fileprivate static var cellReuseIndentifier:String {
        get{
            return "ItemCell"
        }
    }
    
    fileprivate static func getCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath
        ) -> ItemCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIndentifier, for: indexPath) as! ItemCollectionViewCell
        cell.titleLabel.text = "\(indexPath.section)-\(indexPath.item)"
        return cell
    }
    
}
