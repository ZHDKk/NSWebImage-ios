//
//  BookModel.h
//  SDWebImage
//
//  Created by zh dk on 2017/9/1.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
//书名
@property (retain,nonatomic) NSString *bookName;
//书价格
@property (retain,nonatomic) NSString *bookPrice;

//出版社
@property (retain,nonatomic) NSString *publisher;
//图书地址
@property (retain,nonatomic) NSString *imageUrl;

@end
