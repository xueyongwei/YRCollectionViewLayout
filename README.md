# YRCollectionViewLayout
常见的UICollectionViewLayout布局，分组背景色、行对齐、Excel表格等。

### 使用方法

1. 下载layout文件，拷贝进工程。
2. 创建layout：
```
let layout = YRSectionBgColorFlowLayout()
```
3. 创建CollectionView(Controller)：
```
let vc = YRbgcCollectionViewController.init(collectionViewLayout: layout)
```
3. **DONE**

### 效果展示

##### 分组背景色、圆角等

![效果](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRSectionBgColor.gif)


##### 改变每一行的对齐方式(等间距)

![居中](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRAlignLineCenter.gif)

![居左](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRAlignLineLeft.gif)

![居右](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRAlignLineRight.gif)

##### Excel的表格锁定行列、类似tableView的headerView


![锁定列](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRFormLockV.gif)


![锁定行](https://raw.githubusercontent.com/xueyongwei/YRCollectionViewLayout/master/gif/YRFormLockH.gif)

