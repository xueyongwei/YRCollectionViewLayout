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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }



}


extension YRFormCollectionViewController:YRFormDelegateFlowLayout {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 30)
    }
    
}
