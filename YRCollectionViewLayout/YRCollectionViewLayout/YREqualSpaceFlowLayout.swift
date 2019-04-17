//
//  YREqualSpaceFlowLayout.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/17.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

/// 等间距布局
class YREqualSpaceFlowLayout: UICollectionViewFlowLayout {

    /// 对齐方式
    var alignType:AlignType
    
    /// cell间距
    var spaceBetweenCell:CGFloat = 5
    
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
        
        let layoutAttributes_t = super.layoutAttributesForElements(in: rect)
        
        
    }
}

extension YREqualSpaceFlowLayout {
    
    enum AlignType {
        case left
        case center
        case right
    }
}
