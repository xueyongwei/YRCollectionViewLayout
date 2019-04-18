//
//  YREqualSpaceFlowLayout.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/17.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

/**
 等间距布局（在原布局的基础上，调整为等间距对齐到左、右、中。）
 
 - Note: 不会影响原来的minimumInteritemSpacing和以其计算的每行个数，仅调整每一行的对齐方式
 */
class YREqualSpaceAlignFlowLayout: UICollectionViewFlowLayout {

    /// 对齐方式
    var alignType:AlignType
    
    /// cell间距
    var spaceBetweenCell:CGFloat = 5
    
    /// 居中对齐的时候，需要这个宽度来计算第一个cell的位置
    fileprivate var eachLineWidth:CGFloat = 0
    
    /**
     - Parameters:
        - spaceBetweenCell: 修正后两个cell之间的距离
        - alignType: 对齐方式
     */
    init(spaceBetweenCell:CGFloat,alignType:AlignType) {
        
        self.spaceBetweenCell = spaceBetweenCell
        self.alignType = alignType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutAttributesForElements(
        in rect: CGRect
        ) -> [UICollectionViewLayoutAttributes]? {
        
        guard let originalLayoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        guard var newLayoutAttributes = NSMutableArray.init(array: originalLayoutAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else{
            return originalLayoutAttributes
        }
        
        var eachLineLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (idx,attribute) in newLayoutAttributes.enumerated() {
            
            let current:UICollectionViewLayoutAttributes = attribute
            let previous:UICollectionViewLayoutAttributes? = idx == 0 ? nil : newLayoutAttributes[idx-1]
            let next:UICollectionViewLayoutAttributes? = idx+1 == newLayoutAttributes.count ? nil : newLayoutAttributes[idx+1]
            
            eachLineLayoutAttributes.append(current)
            eachLineWidth += current.frame.size.width
            
            var previousY:CGFloat = 0
            if let pre = previous{
                previousY = pre.frame.maxY
            }
            
            let currentY = current.frame.maxY
            
            var nextY:CGFloat = 0
            if let nxt = next{
                nextY = nxt.frame.maxY
            }
            
            if currentY != previousY && currentY != nextY {//单独一行，可能是header等非Cell，判断一下
                if current.representedElementKind == nil {//是普通的cell
                    updateFrameOf(attributes: &eachLineLayoutAttributes)
                }else {//不是cell，不处理
                    eachLineWidth = 0
                    eachLineLayoutAttributes.removeAll()
                }
            }else if currentY != nextY {//一行有很多，且下一个开始换行，处理这一行的
                updateFrameOf(attributes: &eachLineLayoutAttributes)
            }
        }
        
        return newLayoutAttributes
    }
    
    /// 更新这一行的frame
    fileprivate func updateFrameOf(attributes: inout [UICollectionViewLayoutAttributes]){
        
        var nowX:CGFloat = 0
        
        switch self.alignType {
        case .left:
            nowX = self.sectionInset.left
            for attribute in attributes {
                var frame = attribute.frame
                if let layout = collectionView?.collectionViewLayout,
                    let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
                    let inset = delegate.collectionView?(collectionView!, layout: layout, insetForSectionAt: attribute.indexPath.section){
                    nowX = inset.left
                }
                frame.origin.x = nowX
                attribute.frame = frame
                nowX += frame.size.width + spaceBetweenCell
            }
        case .center:
            let spaceTotalWidth = collectionView!.frame.size.width - eachLineWidth
            let leftRightWidth = spaceTotalWidth - (CGFloat(attributes.count - 1) * spaceBetweenCell)
            nowX = leftRightWidth / 2;
            for attribute in attributes{
                var frame = attribute.frame
                frame.origin.x = nowX
                attribute.frame = frame
                nowX += frame.size.width + spaceBetweenCell
            }
        case .right:
            nowX = collectionView!.frame.size.width - sectionInset.right
            for attribute in attributes.reversed() {//从最右开始
                if let layout = collectionView?.collectionViewLayout,
                    let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
                    let inset = delegate.collectionView?(collectionView!, layout: layout, insetForSectionAt: attribute.indexPath.section){
                    nowX = collectionView!.frame.size.width - inset.right
                }
                var frame = attribute.frame;
                frame.origin.x = nowX - frame.size.width;
                attribute.frame = frame;
                nowX = nowX - frame.size.width - spaceBetweenCell;
            }
        }
        
        eachLineWidth = 0
        attributes.removeAll()
        
    }
}

extension YREqualSpaceAlignFlowLayout {
    
    enum AlignType {
        case left
        case center
        case right
    }
}
