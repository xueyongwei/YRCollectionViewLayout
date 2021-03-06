//
//  ACollectionViewFlowLayout.swift
//  collection
//
//  Created by 薛永伟 on 2018/10/24.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

/// 遵循这个协议，实现特殊定制
protocol YRSectionBgColorDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    /// 背景色
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
    
    /// 向四周扩展的edgeInset（仅在）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, edgeInsetExtendedFor section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sectionCornerRadiusFor section: Int) -> CGFloat
}


/**
 分组添加背景色及圆角布局
 
 - Note: 准守实现YRSectionBgColorDelegateFlowLayout协议，个性化定制四周扩展偏移、背景色、圆角大小等。
 */
class YRSectionBgColorFlowLayout: UICollectionViewFlowLayout {
    
    /// 装饰视图的属性
    fileprivate var decorationAtts = [YRSBCLayoutAttributes]()
    
    
    override func prepare() {
        
        super.prepare()
        
        
        self.register(YRSBCDecorationView.self, forDecorationViewOfKind: YRSBCLayoutAttributes.decorationViewKind)
        
        guard let deleagte = self.collectionView?.delegate as? YRSectionBgColorDelegateFlowLayout,let numberOfSections = self.collectionView?.numberOfSections else { return  }
        
        decorationAtts.removeAll()
        
        for section in 0..<numberOfSections {
            
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),numberOfItems > 0 ,
                let firstItem = self.layoutAttributesForItem(at: IndexPath.init(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath.init(item: numberOfItems - 1, section: section))
                else {
                    
                    continue
            }
            
            var maxX:CGFloat = 0
            var maxXItem: UICollectionViewLayoutAttributes?
            var maxY:CGFloat = 0
            var maxYItem: UICollectionViewLayoutAttributes?
            
            for i in 0..<numberOfItems {
                let indexPath = IndexPath.init(item: i, section: section)
                if let item = self.layoutAttributesForItem(at: indexPath){
                    if item.frame.origin.x > maxX {
                        maxX = item.frame.origin.x
                        maxXItem = item
                    }
                    if item.frame.origin.y > maxY {
                        maxY = item.frame.origin.y
                        maxYItem = item
                    }
                }
            }
            
            let edgeInset = deleagte.collectionView(collectionView!, layout: self, edgeInsetExtendedFor: section)
            
            
            // sectionFrame，紧缩包含所有的item，从第一个Cell到最后一个Cell
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            
            if let mxItem = maxXItem,let myItem = maxYItem {
                let mxyFrame = mxItem.frame.union(myItem.frame)
                sectionFrame = sectionFrame.union(mxyFrame)
            }
            
            
            sectionFrame.origin.x -= edgeInset.left
            
            sectionFrame.origin.y -= edgeInset.top
            
            sectionFrame.size.width += (edgeInset.left + edgeInset.right)
            
            sectionFrame.size.height += (edgeInset.top + edgeInset.bottom)
            
            /// 创建一个attribute
            let newAtt = YRSBCLayoutAttributes(forDecorationViewOfKind: YRSBCLayoutAttributes.decorationViewKind, with: IndexPath(item: 0, section: section))
            newAtt.frame = sectionFrame
            newAtt.zIndex = -1
            
            let bgColor = deleagte.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            newAtt.bgColor = bgColor
            
            let cornerRadius = deleagte.collectionView(collectionView!, layout: self, sectionCornerRadiusFor: section)
            newAtt.cornerRadius = cornerRadius
            
            decorationAtts.append(newAtt)
        }
        
    }
    
    override func layoutAttributesForElements(
        in rect  : CGRect
        ) -> [UICollectionViewLayoutAttributes]? {
        
        var attrs = super.layoutAttributesForElements(in: rect)
        let bgAtts = self.decorationAtts.filter({ (att) -> Bool in
            return rect.intersects(att.frame)
        })
        attrs?.append(contentsOf: bgAtts)
        
        return attrs
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false
    }
}

//MARK: - --------------YRSBCDecorationView--------------

/// 装饰视图
class YRSBCDecorationView: UICollectionReusableView {
    
    //MARK:属性
    private var defaultBackgroundColor = UIColor.white
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.apply(layoutAttributes)
        if let att = layoutAttributes as? YRSBCLayoutAttributes {
            self.backgroundColor =  att.bgColor
            self.layer.cornerRadius = att.cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        customSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        customSubviews()
    }
    
    func customSubviews(){
        
        self.backgroundColor =  defaultBackgroundColor
        self.layer.cornerRadius = 10
    }
}


//MARK: - --------------YRSBCLayoutAttributes--------------
/// LayoutAttributes
class YRSBCLayoutAttributes: UICollectionViewLayoutAttributes{
    
    var bgColor = UIColor.white
    var cornerRadius:CGFloat = 10
    
    /// 标识符
    static var decorationViewKind = "YRSBCDecorationView"
    
}
