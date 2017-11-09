//
//  ViewController.m
//  SDWebImage
//
//  Created by zh dk on 2017/9/1.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BookModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"加载网络视图demo";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //设置数据视图代理协议
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //自动调整视图大小属性
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_tableView];
    
    _arrayData = [[NSMutableArray alloc]init];
    
    
    _barLoadData = [[UIBarButtonItem alloc]initWithTitle:@"加载" style:UIBarButtonItemStylePlain target:self action:@selector(pressLoad)];
    self.navigationItem.rightBarButtonItem = _barLoadData;
}

//加载新的数据
-(void)pressLoad
{
//    static int i =0;
//    for (int j=0; j<10;j++,i++) {
//        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
//        [_arrayData addObject:str];
//    }
    
    [self loadDataFromNet];
    

}
//网络获取数据
-(void) loadDataFromNet
{
    //获取对象，用来下载网络数据
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSArray *arrayG = [NSArray arrayWithObjects:@"iOS",@"Android",@"C++", nil];
    static int  counter = 0;
    NSString *strPath = [NSString stringWithFormat:@"http://api.douban.com/book/subjects?q=%@&alt=json&apikey=01987f93c544bbfb04c97ebb4fce33f1",arrayG[counter]];
    counter ++;
    if (counter >=3) {
        counter = 0;
    }
    //下载网络数据
    [session GET:strPath parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        NSLog(@"下载成功");
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             NSLog(@"dic = %@",responseObject);
             [self parseData:responseObject];
         }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        NSLog(@"下载失败");
    }];
}
//解析数据
-(void)parseData:(NSDictionary*)dicData
{
    NSArray *arrayEntry = [dicData objectForKey:@"entry"];
    for (NSDictionary* dicBook in arrayEntry) {
        NSDictionary *dicTitle = [dicBook objectForKey:@"title"];
        NSString *strTitle = [dicTitle objectForKey:@"$t"];
        BookModel *book = [[BookModel alloc] init];
        book.bookName = strTitle; //获取书籍名字
        
        NSArray *arrayLink = [dicBook objectForKey:@"link"];
        for (NSDictionary *dicLink  in arrayLink) {
            if ([[dicLink objectForKey:@"@rel"] isEqualToString:@"image"]) {
                NSString *strLink = [dicLink objectForKey:@"@href"];
                book.imageUrl = strLink;
            }
        }
        
        NSArray *arrayAttr = [dicBook objectForKey:@"db:attribute"];
        for (NSDictionary *dicAttr in arrayAttr) {
            if ([[dicAttr objectForKey:@"@name"] isEqualToString:@"price"]) {
                NSString *strPrice = [dicAttr objectForKey:@"$t"];
                book.bookPrice = strPrice;
            }
            else if ([[dicAttr objectForKey:@"@name"] isEqualToString:@"publisher"]){
                NSString *strPub = [dicAttr objectForKey:@"$t"];
                book.publisher = strPub;
            }
        }
        
        [_arrayData addObject:book];
    }
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strID = @"ID";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:strID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    BookModel *book = _arrayData[indexPath.row];
    cell.textLabel.text =book.bookName;
    cell.detailTextLabel.text = book.bookPrice;
    cell.detailTextLabel.text = book.publisher;
    
    //使用webimage来加载网络图片
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:book.imageUrl] placeholderImage:[UIImage imageNamed:@"1.png"]];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
