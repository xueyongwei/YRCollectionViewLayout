//
//  YRLeftAlignFlowLayout.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/5/8.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

class YRLeftAlignFlowLayout: UICollectionViewFlowLayout {

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        if let originalAttributes = super.layoutAttributesForElements(in: rect){

            var updatedAttributes = [UICollectionViewLayoutAttributes].init(originalAttributes)


            for (idx,attributes) in originalAttributes.enumerated(){
                if attributes.representedElementKind == nil,
                    attributes.frame.intersects(rect),
                    let newAttributes = self.layoutAttributesForItem(at: attributes.indexPath){
                    
                    updatedAttributes[idx] = newAttributes
                }
            }
            return updatedAttributes
        }
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        
        let sectionInset = self.evaluatedSectionInset(for: indexPath.section)
        
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
            return currentItemAttributes
        }
        
        let previousIndexPath = IndexPath.init(item: indexPath.item - 1, section: indexPath.section)
        
        if let previousFrame = super.layoutAttributesForItem(at: previousIndexPath)?.frame {
            let previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect.init(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)
            
            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            if isFirstItemInRow {
                currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
                return currentItemAttributes
            }
            
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(for: indexPath.section)
            currentItemAttributes.frame = frame
            return currentItemAttributes
        }
        
        
        return currentItemAttributes
        
    }
    
}


extension YRLeftAlignFlowLayout{
    
    func evaluatedMinimumInteritemSpacing(for section:Int) -> CGFloat {
        
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
            let spacing = delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section){
            return spacing
        }else{
            return self.minimumInteritemSpacing
        }
    }
    
    func evaluatedSectionInset(for section:Int) -> UIEdgeInsets {
        
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
            let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section){
            return inset
        }else{
            return self.sectionInset
        }
    }
}

extension UICollectionViewLayoutAttributes {
    
    /// 对齐sectionInset
    func leftAlignFrameWithSectionInset(sectionInset:UIEdgeInsets){
        
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}
