//
//  ViewController.h
//  SDWebImage
//
//  Created by zh dk on 2017/9/1.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
        //声明数据视图
    UITableView *_tableView;
    //声明数据源对象
    NSMutableArray *_arrayData;
    //加载视图
    UIBarButtonItem *_barLoadData;
    //编辑按钮
    UIBarButtonItem *_btnEdit;
}


@end

