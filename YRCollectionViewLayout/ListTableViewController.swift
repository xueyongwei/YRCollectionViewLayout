//
//  ListTableViewController.swift
//  YRCollectionViewLayout
//
//  Created by 薛永伟 on 2019/4/17.
//  Copyright © 2019 Yuri. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    //MARK:属性
    
    var dataSource:[Item] = [
        Item.sectionBgColor
    ]
    
    //MARK:控件
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = dataSource[indexPath.row]
        if let desVC = item.getDemoController() {
            self.navigationController?.pushViewController(desVC, animated: true)
        }
    }

    

}

//MARK: - --------------类--------------
extension ListTableViewController {
    
    enum Item {
        
        case sectionBgColor
        case undefined
        
        var name:String{
            switch self {
            case .sectionBgColor:
                return "分区背景色"
            default:
                return "未定义"
            }
        }
        
    }
    
    
}
//MARK: - --------------响应事件--------------

//MARK: - --------------数据请求--------------

//MARK: - --------------辅助方法--------------
extension ListTableViewController {
    
    
}

extension ListTableViewController.Item {
    
    func getDemoController() -> UIViewController? {
        
        switch self {
        case .sectionBgColor:
            let layout = YRbcsFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize.init(width: 80, height: 80)
            layout.sectionInset = UIEdgeInsets.init(top: 20, left: 15, bottom: 20, right: 15)
            
            let vc = YRbgcCollectionViewController.init(collectionViewLayout: layout)
            return vc
        default:
            return nil
        }
        
    }
}
//MARK: - --------------驱动UI--------------
