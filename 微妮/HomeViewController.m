//
//  HomeViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "HomeViewController.h"
#import "tencentCell.h"
#import "UserInfoData.h"
#import "WeiboCell.h"
#import "DetailViewController.h"

// 新浪微博
#define kSinaPublicWeibo    @"https://api.weibo.com/2/statuses/public_timeline.json"    // 公共微博
#define kSinaFriends        @"https://api.weibo.com/2/statuses/public_timeline.json"    // 朋友圈
#define kSinaUser           @"https://api.weibo.com/2/statuses/user_timeline.json"      // 我
#define kSinaAttention      @"https://api.weibo.com/2/statuses/user_timeline.json"      // 关注

// 腾讯微博
#define kTencentPublicWeibo @"http://open.t.qq.com/api/statuses/public_timeline"        // 公共微博
#define kTencentFriends     @"http://open.t.qq.com/api/statuses/home_timeline"          // 我
#define kTencentUser        @"http://open.t.qq.com/api/statuses/broadcast_timeline"     // 朋友圈
#define kTencentAttention   @"http://open.t.qq.com/api/api/statuses/mentions_timeline"  // 关注

typedef void (^selectedBlock) (NSString *);

@interface WeiboClassifyList : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) selectedBlock     block;
@property (nonatomic, strong) NSArray           *Weibolist;     // 微博内容项

@end

@interface HomeViewController (){
    UserInfoData *userInfoRequset;
    // tencent
    int _pageflag;           // 用于翻页（0：第一页，1：向下翻页，2：向上翻页）
    NSInteger _pagetime;     // (0:第一页)填上一次请求返回的最后一条记录时间
}
@property (nonatomic) BOOL      isLoadMore;     // 是否加载更多
@property (nonatomic) int       page;           // 加载的页数
@property (nonatomic) NSInteger lastTime;       // 最后一条微博的时间
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *weiboData;
@property (nonatomic, strong) NSString          *selectedName;      // 选择的内容项
@property (nonatomic, strong) NSDictionary      *sinaListData;      // 新浪微博内容项
@property (nonatomic, strong) NSDictionary      *tencentListData;   // 腾讯微博内容项
@property (nonatomic, strong) WeiboClassifyList *weiboTable;        // 内容项视图
@property (nonatomic, strong) UIButton          *selectedButton;    // 选择内容项按钮

@end

@implementation HomeViewController

#pragma mark - LifeCircle

- (id)init {
    self = [super init];
    if (self) {
        _page       = 1;
        _isLoadMore = NO;
        _pageflag   = 0;
        _pagetime   = 0;
        _lastTime   = 0;
        // 加载数据
        userInfoRequset = [[UserInfoData alloc]init];
        _weiboData = [[NSMutableArray alloc]init];
        _sinaListData = @{@"最新微博" : kSinaPublicWeibo,
                          @"朋友圈" : kSinaFriends,
                          @"我的微博" : kSinaUser,
                          @"我的关注" : kSinaAttention,
                          };
        _tencentListData = @{@"最新微博" : kTencentPublicWeibo,
                           @"朋友圈" : kTencentFriends,
                           @"我的微博" : kTencentUser,
                           @"我的关注" : kTencentAttention,
                           };
        _selectedName = @"最新微博";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航
    [self setTitle:@"首页"];
    _selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_selectedButton setFrame:CGRectMake(60, 0, 200, 44)];
    [_selectedButton setTitle:@"首页" forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(changeWeiboList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _selectedButton;
    
    // tableview
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    [self.view addSubview:self.tableView];
    
    // 集成刷新控件
    [self setupRefresh];
    
    // 内容项视图
    _weiboTable = [[WeiboClassifyList alloc]initWithFrame:CGRectMake(110, 64, 100, 120) style:UITableViewStylePlain];
    _weiboTable.Weibolist = [NSArray arrayWithObjects:@"最新微博",@"朋友圈",@"我的微博",@"我的关注", nil];
    __weak typeof(self) weakSelf = self;
    _weiboTable.block = ^(NSString *a){
        // 导航上显示
        [weakSelf.selectedButton setTitle:a forState:UIControlStateNormal];
        // 使选择视图消失
        weakSelf.weiboTable.hidden = YES;
        NSLog(@"block%@",a);
        weakSelf.selectedName = a;
        // 刷新视图
        [weakSelf headerRereshing];
    };
    [self.view addSubview:_weiboTable];
    [_weiboTable setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 自动刷新程序
    [self headerRereshing];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark - ChangeAction

/**
 *  切换微博列表
 *
 *  @param button 按钮
 */
-(void)changeWeiboList:(UIButton *)button{
    if (_weiboTable.isHidden) {
        // 出现内容项视图
        [_weiboTable setHidden:NO];
    }else{
        // 隐藏内容项视图
        [_weiboTable setHidden:YES];
    }
}

#pragma mark - LoadWeiboData
/**
 *  加载微博数据
 */
-(void)loadWeiboData{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    // 获取到当前微博
    NSString *weiboName =[SelectedWeiboName sharedWeiboName].weiboName;
    if ([weiboName isEqualToString:@"新浪微博"]&&[userData objectForKey:@"token"]) {
        // 新浪微博
        NSString *sinaUrl = [NSString stringWithFormat:@"%@?&access_token=%@&page=%d&count=5",[_sinaListData objectForKey:_selectedName],[userData objectForKey:@"token"],_page];
        // 请求数据
        [userInfoRequset getUserDataWithUrlStr:sinaUrl];
        __weak typeof(self) weakSelf = self;
        //回调数据处理
#warning errorDeal
        userInfoRequset.block = ^(NSMutableDictionary *dic){
            if (weakSelf.isLoadMore) {
                [weakSelf.weiboData addObjectsFromArray:[dic objectForKey:@"statuses"]];
            }else{
                weakSelf.weiboData = [NSMutableArray arrayWithArray:[dic objectForKey:@"statuses"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新数据
                [weakSelf.tableView reloadData];
                if (!weakSelf.isLoadMore) {
                    //滚动到首行
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            });
        };
    }else if([weiboName isEqualToString:@"腾讯微博"]&&[userData objectForKey:@"tencent_token"]) {
        // 腾讯微博
        // 通用参数oauth_consumer_key&access_token&openid&clientip&oauth_version=2.a&scope=all
        // 最新微博参数format=json&pos=0&reqnum=20
        // 参数format=json&pageflag=0&pagetime=0&reqnum=20&lastid=0&type=0&contenttype=0
        NSMutableString *tencentUrl = [NSMutableString stringWithFormat:@"%@?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a&type=0&clientip=127.0.0.1&scope=all&reqnum=10",[_tencentListData objectForKey:_selectedName],kTAppKey,[userData objectForKey:@"tencent_token"],[userData objectForKey:@"openid"]];
        if ([_selectedName isEqualToString:@"最新微博"]) {
            [tencentUrl appendString:@"&pos=0"];
        }else{
            [tencentUrl appendFormat:@"&pageflag=%d&pagetime=%ld&lastid=0&type=0&contenttype=0",_pageflag,(long)_pagetime];
        }
        // 请求数据
        [userInfoRequset getUserDataWithUrlStr:tencentUrl];
        // 处理回调数据
         __weak typeof(self) weakSelf = self;
        userInfoRequset.block = ^(NSMutableDictionary *dic){
            if ([[dic objectForKey:@"ret"]integerValue] == 0) {
                //ret : 返回值，0-成功，非0-失败,
                if (weakSelf.isLoadMore) {
                    [weakSelf.weiboData addObjectsFromArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }else{
                    weakSelf.weiboData = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }
                weakSelf.lastTime = [[[dic objectForKey:@"data"]objectForKey:@"timestamp"]intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新数据
                    [weakSelf.tableView reloadData];
                });
            }
        };
    }
}

#pragma mark Refesh

- (void)headerRereshing
{
    _page       = 1;
    _isLoadMore = NO;
    _pagetime   = 0;
    _pageflag   = 0;
    
    [self loadWeiboData];
    [self.tableView headerEndRefreshing];
}

- (void)footerRereshing
{
    if ([self.selectedName isEqualToString:@"我的微博"]) {
        _page++;
    }else{
        _page--;
    }
    
    _isLoadMore = YES;
    _pagetime   = _lastTime;
    _pageflag   = 1;
    
    [self loadWeiboData];
    [self.tableView footerEndRefreshing];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weiboData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.weiboData objectAtIndex:indexPath.row];
    // 行高
    int iTop = [WeiboCell heightWith:dict WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
    return iTop;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.weiboData objectAtIndex:indexPath.row];
    WeiboCell *cell = [[WeiboCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContentData:dict];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 查看详情
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.singelWeiboData = [self.weiboData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - NSNotifiction actions

// 当切换主题时会调用
-(void)weiboNotification:(NSNotification *)notification{
    NSLog(@"home切换主题");
    // 请求数据
    [self headerRereshing];
}

@end

#pragma mark - WeiboClassifyList

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
    // 通知主视图刷新数据
    _block([_Weibolist objectAtIndex:indexPath.row]);
}

@end