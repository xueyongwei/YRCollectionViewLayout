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
 - Warning: 布局未适配刘海屏幕的旋转等，需要自行适配CollectionView的safeArea
 */
class YRFormFLowLayout: UICollectionViewFlowLayout {

    /// 锁定列书
    var suspendRowNum:Int = 0
    /// 锁定行书
    var suspendSectionNum:Int = 0
    
    /// 每个cell的大小
    fileprivate var itemsSizeSource:[[CGSize]] = [[CGSize]]()
    
    fileprivate var contentSize:CGSize = CGSize.zero
    
    fileprivate var layoutAttributes:[[UICollectionViewLayoutAttributes]] = [[UICollectionViewLayoutAttributes]]()
    
    
    
    //MARK: -
    
    override func prepare() {
        
        let sectionNumbers = collectionView!.numberOfSections
        
        if sectionNumbers == 0  {
            
            return
        }
        
        if self.layoutAttributes.count > 0 {//有布局数据
            showRangedAttributes()
            return
        }
        
        
        rangeContentItemsAttributes()
        
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return layoutAttributes[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var result = [UICollectionViewLayoutAttributes]()
        
        for section in layoutAttributes {
            
            let arr = section.filter { (attribute) -> Bool in
                return rect.intersects(attribute.frame)
            }
            result.append(contentsOf: arr)
        }
        return result
    }
    
    
    
    override var collectionViewContentSize: CGSize {
        
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
    }
    
    func reload(){
        
        self.layoutAttributes.removeAll()
        self.itemsSizeSource.removeAll()
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
    
    /// 组合item的attributes
    fileprivate func rangeContentItemsAttributes(){
        
        var column:Int                  = 0;//列
        var xOffset:CGFloat             = 0.0;//X方向的偏移量
        var yOffset:CGFloat             = 0.0;//Y方向的偏移量
        var contentWidth:CGFloat        = 0.0;//collectionView.contentSize的宽度
        var contentHeight:CGFloat       = 0.0;//collectionView.contentSize的高度
        
        
      
        let sectionNumbers = collectionView!.numberOfSections
        
        layoutAttributes.removeAll()
        itemsSizeSource.removeAll()
        
        calculateItemsSize()
        
        for section in 0..<sectionNumbers {
            
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            let itemNumbers = collectionView!.numberOfItems(inSection: section)
            
            for item in 0..<itemNumbers{
                
                let itemSize = self.itemsSizeSource[section][item]
                let indexPath = IndexPath.init(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attributes.frame = CGRect.init(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                
                if section < suspendSectionNum && item < suspendRowNum {
                    attributes.zIndex = 1000
                }else if section < suspendSectionNum || item < suspendRowNum{
                    attributes.zIndex = 999
                }
                
//                if section < suspendSectionNum {
//                    var frame = attributes.frame
//                    var offsetY:CGFloat = 0
//                    for y in 0..<section {
//                        offsetY = itemsSizeSource[y][item].height
//                    }
//                    frame.origin.y = collectionView!.contentOffset.y + offsetY
//                    attributes.frame = frame
//                }
//
//                if item < suspendRowNum {
//                    var frame = attributes.frame
//                    var offsetX:CGFloat = 0
//                    for x in 0..<section {
//                        offsetX = itemsSizeSource[section][x].width
//                    }
//                    frame.origin.x = collectionView!.contentOffset.x + offsetX
//                    attributes.frame = frame
//                }
                
                sectionAttributes.append(attributes)
                xOffset += itemSize.width
                column += 1
                
                if column == collectionView!.numberOfItems(inSection: 0){//折行
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            layoutAttributes.append(sectionAttributes)
            
        }
        
        if let lastAttribute = layoutAttributes.last?.last{
            contentHeight = lastAttribute.frame.origin.y + lastAttribute.frame.size.height
            contentSize = CGSize.init(width: contentWidth, height: contentHeight)
        }
    }
    
    /// 显示组合好的attribute
    fileprivate func showRangedAttributes(){
        
        let sectionNumbers = collectionView!.numberOfSections
        
        for section in 0..<sectionNumbers {
            
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            
            for item in 0..<numberOfItems {
                
                // 非锁定区域 不固定 直接过滤
                if (item >= suspendRowNum && section >= suspendSectionNum) {
                    continue;
                }
                
                let indexPath = IndexPath.init(item: item, section: section)
                
                if let attributes = layoutAttributesForItem(at: indexPath){
                    if section < suspendSectionNum {//锁定行
                        var frame = attributes.frame
                        var offsetY:CGFloat = 0
                        for y in 0..<section {
                            offsetY += itemsSizeSource[y][item].height
                        }
                        
                        var contentInsetTop:CGFloat = collectionView!.contentInset.top
                        
                        if #available(iOS 11.0, *) {
                            contentInsetTop += collectionView!.adjustedContentInset.top
                        }
                        
                        frame.origin.y          = collectionView!.contentOffset.y + contentInsetTop + offsetY
                        attributes.frame        = frame;
                    }
                    
                    if item < self.suspendRowNum {//锁定列
                        var frame = attributes.frame
                        var offsetX:CGFloat = 0
                        for x in 0..<item {
                            offsetX +=  itemsSizeSource[section][x].width
                        }
                        
                        var contentInseLeft:CGFloat = collectionView!.contentInset.left
                        
                        if #available(iOS 11.0, *) {
                            contentInseLeft += collectionView!.adjustedContentInset.left
                        }
                        
                        frame.origin.x = collectionView!.contentOffset.x + contentInseLeft + offsetX
                        attributes.frame = frame;
                    }
                }
            }
        }
    }
}
