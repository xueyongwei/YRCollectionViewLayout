//
//  YRFormFLowLayout.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/18.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

protocol YRFormDelegateFlowLayout:UICollectionViewDelegateFlowLayout {
    
    /// 每个item的大小，将会使collectionView的itemSize强制使用这个大小
    func sizeForItem(at indexPath:IndexPath) -> CGSize
}


/**
 表格（Excel）布局
 - Note: section这里指行，item这里指列。即一个section占一行。
 */
class YRFormFLowLayout: UICollectionViewFlowLayout {

    var suspendRowNum:Int = 0
    var suspendSectionNum:Int = 0
    
    /// 每个cell的大小
    fileprivate var itemsSizeSource:[[CGSize]] = [[CGSize]]()
    
    fileprivate var contentSize:CGSize = CGSize.zero
    
    fileprivate var layoutAttributes:[[UICollectionViewLayoutAttributes]] = [[UICollectionViewLayoutAttributes]]()
    
    override func prepare() {
        
        
        guard let sectionNumbers = collectionView?.numberOfSections else {
            return
        }
        
        calculateItemsSize()
        
        var allLineHeight:CGFloat = 0
        for section in 0..<sectionNumbers {
            
            guard let itemNumbers = collectionView?.numberOfItems(inSection: section),
            itemNumbers > 0 else {
                continue
            }
            
//            let firstAttribute = self.layoutAttributesForItem(at: IndexPath.init(item: 0, section: section))
            let firstSize = self.itemsSizeSource[section][0]
            allLineHeight += firstSize.height
            
            /// 这一行的y值
            let lineY = CGFloat(section) * firstSize.height
            
            var lineTotalWidht:CGFloat = 0
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            
            for item in 0..<itemNumbers {//这一个section里的所有item都放到一行
                
                
                let indexPath = IndexPath.init(item: item, section: section)
                
                let size = self.itemsSizeSource[section][item]
                
                lineTotalWidht += size.width
                let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
//                guard let attribute = self.layoutAttributesForItem(at: indexPath) else {
//                    continue
//                }
                
                let itemX = CGFloat(item) * size.width
                
                attribute.frame = CGRect.init(x: itemX, y: lineY, width: size.width, height: size.height)
                sectionAttributes.append(attribute)
            }
            contentSize.width = lineTotalWidht
            layoutAttributes.append(sectionAttributes)
        }
        contentSize.height = allLineHeight
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return layoutAttributes[indexPath.section][indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        
        return contentSize
    }
    
}

//MARK: - --------------计算大小--------------
extension YRFormFLowLayout {
    
    /// 计算每个item的大小
    func calculateItemsSize(){
        
        guard let layoutDelegate = collectionView?.delegate as? YRFormDelegateFlowLayout else{
            return
        }
        
        itemsSizeSource.removeAll()
        
        let sectionNumbers = collectionView!.numberOfSections
        for section in 0..<sectionNumbers{
            
            var sectionItemsSizeSource = [CGSize]()
            let itemNumbers = collectionView!.numberOfItems(inSection: section)
            for item in 0..<itemNumbers{
                let itemSize = layoutDelegate.sizeForItem(at: IndexPath.init(item: item, section: section))
                sectionItemsSizeSource.append(itemSize)
            }
            itemsSizeSource.append(sectionItemsSizeSource)
        }
    }
}
