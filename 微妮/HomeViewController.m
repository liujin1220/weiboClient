//
//  HomeViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "HomeViewController.h"
#import "SinaCell.h"
#import "tencentCell.h"
#import "WeiboApiObject.h"

#define kSinaPublicWeibo @"https://api.weibo.com/2/statuses/public_timeline.json"
#define kSinaFriends @"https://api.weibo.com/2/statuses/public_timeline.json"
#define kSinaUser @"https://api.weibo.com/2/statuses/user_timeline.json"
#define kSinaAttention @"https://api.weibo.com/2/statuses/user_timeline.json"

#define kTencentPublicWeibo @"statuses/public_timeline"
#define kTencentFriends @"statuses/home_timeline"
#define kTencentUser @"statuses/broadcast_timeline"
#define kTencentAttention @"api/statuses/mentions_timeline "

@interface WeiboClassifyList : UITableView<UITableViewDataSource,UITableViewDelegate>
//定义一个Block类型
typedef void (^selectedBlock) (NSString *);
@property(nonatomic,strong)selectedBlock block;
@property(nonatomic,strong)NSArray *Weibolist;
@end

@interface HomeViewController ()
@property(nonatomic,strong)WeiboApi *txwb;
@property(nonatomic,strong)NSString *selectedName;
@property(nonatomic,strong)NSDictionary *listData;
@property(nonatomic,strong)NSDictionary *tlistData;
@property(nonatomic,strong)WeiboClassifyList *weiboTable;
@property(nonatomic,strong)NSMutableArray *txweiboData;
@property(nonatomic,strong)UIButton *selectedButton;
@end

@implementation HomeViewController
-(id)init{
    self = [super init];
    if (self) {
        _txweiboData = [[NSMutableArray alloc]init];
        _weiboData = [[NSMutableArray alloc]init];
        _listData = [NSDictionary dictionaryWithObjectsAndKeys:kSinaPublicWeibo,@"最新微博",kSinaFriends,@"朋友圈",kSinaUser,@"我的微博",kSinaAttention,@"我的关注", nil];
        _tlistData = [NSDictionary dictionaryWithObjectsAndKeys:kTencentPublicWeibo,@"最新微博",kTencentFriends,@"朋友圈",kTencentUser,@"我的微博",kTencentAttention,@"我的关注",nil];
        _selectedName = @"最新微博";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.txwb == nil)
    {
        self.txwb = [[WeiboApi alloc]initWithAppKey:KTAppKey andSecret:KTAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
    //nav
    [self setTitle:@"首页"];
    //导航
    _selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_selectedButton setFrame:CGRectMake(60, 0, 200, 44)];
    [_selectedButton setTitle:@"首页" forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(changeWeiboList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _selectedButton;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser:)];
    
    self.pullTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    [self.pullTableView setSeparatorInset:UIEdgeInsetsMake(15,0,0,15)];
    [self.view addSubview:self.pullTableView];
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    
    _weiboTable = [[WeiboClassifyList alloc]initWithFrame:CGRectMake(110, 64, 100, 120) style:UITableViewStylePlain];
    _weiboTable.Weibolist = [NSArray arrayWithObjects:@"最新微博",@"朋友圈",@"我的微博",@"我的关注", nil];
    __weak typeof(self) weakSelf = self;
    _weiboTable.block = ^(NSString *a){
        //导航上显示
        [weakSelf.selectedButton setTitle:a forState:UIControlStateNormal];
        //使选择视图消失
        weakSelf.weiboTable.hidden = YES;
        NSLog(@"block%@",a);
        weakSelf.selectedName = a;
        //刷新视图
        [weakSelf loadWeiboData];
    };
    [self.view addSubview:_weiboTable];
    [_weiboTable setHidden:YES];
}
//切换微博列表
-(void)changeWeiboList:(UIButton *)button{
    if (_weiboTable.isHidden) {
        //出现tableview
        [_weiboTable setHidden:NO];
    }else{
        //隐藏
        [_weiboTable setHidden:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    }
}
//添加微博账号
-(void)addUser:(id)sender
{
    //
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadWeiboData];
}
- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - loadWeiboData
-(void)loadWeiboData{
    NSLog(@"selectedname = %@",_selectedName);
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    //获取到当前微博
    NSString *weiboName =[SelectedWeiboName sharedWeiboName].weiboName;
    if ([weiboName isEqualToString:@"新浪微博"]&&[userData objectForKey:@"token"]) {
        //新浪微博
        NSURL *sinaUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?&source=%@&access_token=%@",[_listData objectForKey:_selectedName],KSAppKey,[userData objectForKey:@"token"]]];
        [self request:sinaUrl];
    }else if([weiboName isEqualToString:@"腾讯微博"]&&[userData objectForKey:@"tencentToken"]){
        //腾讯微博
        //通用参数oauth_consumer_key&access_token&openid&clientip&oauth_version=2.a&scope=all
        //最新微博参数format=json&pos=0&reqnum=20
        //参数format=json&pageflag=0&pagetime=0&reqnum=20&lastid=0&type=0&contenttype=0
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                       KTAppKey,@"oauth_consumer_key",
                                       [userData objectForKey:@"tencentToken"], @"access_token",
                                       [userData objectForKey:@"tencentUid"], @"openid",
                                       @"2.a", @"oauth_version",
                                       @"0", @"type",
                                       @"127.0.0.1", @"clientip",
                                       @"all",@"scope",
                                       [NSNumber numberWithInt:10],@"reqnum",
                                       nil];
        if ([_selectedName isEqualToString:@"最新微博"]) {
            [params setObject:[NSNumber numberWithInt:0] forKey:@"pos"];
        }else{
            [params setObject:[NSNumber numberWithInt:0] forKey:@"pageflag"];
            [params setObject:[NSNumber numberWithInt:0] forKey:@"pagetime"];
            [params setObject:[NSNumber numberWithInt:0] forKey:@"lastid"];
            [params setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            [params setObject:[NSNumber numberWithInt:0] forKey:@"contenttype"];
        }
        NSString *apiNameStr = [NSString stringWithString:[_tlistData objectForKey:_selectedName]];
        if ([_txwb requestWithParams:params apiName:apiNameStr httpMethod:@"GET" delegate:self]) {
            //刷新视图
            [self.pullTableView reloadData];
        }
    }
}

#pragma mark - WeiboRequestDelegate
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno{
//    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",strResult);
    if (reqno) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        self.txweiboData = [[dic objectForKey:@"data"]objectForKey:@"info"];
         //NSLog(@"info = %@",dic);
        //刷新视图
        [self.pullTableView reloadData];
    }
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
    });

}
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    NSLog(@"%@",str);
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}
#pragma mark - ASIHTTPRequestDelegate
-(void)request:(NSURL *)urlStr{
    //请求
    ASIHTTPRequest *requestForm = [[ASIHTTPRequest alloc]initWithURL:urlStr];
    //设置代理
    [requestForm setDelegate:self];
    //开始异步请求
    [requestForm startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    //将json数据转化为字典
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];//NSJSONSerialization提供了将JSON数据转换为Foundation对象（一般都是NSDictionary和NSArray）
    self.weiboData = [dic objectForKey:@"statuses"];
    //刷新数据
    [self.pullTableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    //输出错误信息
    NSLog(@"%@",str);
}
#pragma mark - Refresh and load more methods
//下拉刷新事件
- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}
//上拉加载更多
- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        return self.weiboData.count;
    }else{
        return self.txweiboData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
         dict = [self.weiboData objectAtIndex:indexPath.row];
        //行高
        int iTop = [SinaCell heightWith:dict];
        return iTop;
    }else{
        dict = [self.txweiboData objectAtIndex:indexPath.row];
        //行高
        int iTop = [tencentCell heightWith:dict];
        return iTop;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        dict = [self.weiboData objectAtIndex:indexPath.row];
        SinaCell  *cell = [[SinaCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setContent:dict];
        return cell;
    }else{
        dict = [self.txweiboData objectAtIndex:indexPath.row];
        tencentCell  *cell = [[tencentCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setContent:dict];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //查看详情
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotifiction actions
//当切换主题时会调用
-(void)weiboNotification:(NSNotification *)notification{
    NSLog(@"home切换主题");
    //请求数据
    [self loadWeiboData];
}
@end

@implementation WeiboClassifyList

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _Weibolist = [NSArray array];
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorInset:UIEdgeInsetsMake(15,0,0,15)];
    }
    return self;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_Weibolist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifer = @"list";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:0/255.0  green:0/255.0 blue:0/255.0 alpha:0.6]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.text = [_Weibolist objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"didSelectRowAtIndexPath");
  
    //通知主视图刷新数据
    _block([_Weibolist objectAtIndex:indexPath.row]);
}
@end