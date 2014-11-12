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
#import "UserInfoData.h"
#import "weiboCell.h"

//新浪微博
#define kSinaPublicWeibo @"https://api.weibo.com/2/statuses/public_timeline.json"
#define kSinaFriends @"https://api.weibo.com/2/statuses/public_timeline.json"
#define kSinaUser @"https://api.weibo.com/2/statuses/user_timeline.json"
#define kSinaAttention @"https://api.weibo.com/2/statuses/user_timeline.json"

//腾讯微博
#define kTencentPublicWeibo @"http://open.t.qq.com/api/statuses/public_timeline"
#define kTencentFriends @"http://open.t.qq.com/api/statuses/home_timeline"
#define kTencentUser @"http://open.t.qq.com/api/statuses/broadcast_timeline"
#define kTencentAttention @"http://open.t.qq.com/api/api/statuses/mentions_timeline"

@interface WeiboClassifyList : UITableView<UITableViewDataSource,UITableViewDelegate>
//定义一个Block类型
typedef void (^selectedBlock) (NSString *);
@property(nonatomic,strong)selectedBlock block;
@property(nonatomic,strong)NSArray *Weibolist;
@end

@interface HomeViewController (){
    UserInfoData *userInfoRequset;
}
@property(nonatomic,strong)PullTableView *pullTableView;
@property(nonatomic,retain)NSMutableArray *weiboData;
@property(nonatomic,strong)NSString *selectedName;
@property(nonatomic,strong)NSDictionary *listData;
@property(nonatomic,strong)NSDictionary *tlistData;
@property(nonatomic,strong)WeiboClassifyList *weiboTable;
@property(nonatomic,strong)UIButton *selectedButton;
@end

@implementation HomeViewController
-(id)init{
    self = [super init];
    if (self) {
        //加载数据
        userInfoRequset = [[UserInfoData alloc]init];
//        _txweiboData = [[NSMutableArray alloc]init];
        _weiboData = [[NSMutableArray alloc]init];
        _listData = [NSDictionary dictionaryWithObjectsAndKeys:kSinaPublicWeibo,@"最新微博",kSinaFriends,@"朋友圈",kSinaUser,@"我的微博",kSinaAttention,@"我的关注", nil];
        _tlistData = [NSDictionary dictionaryWithObjectsAndKeys:kTencentPublicWeibo,@"最新微博",kTencentFriends,@"朋友圈",kTencentUser,@"我的微博",kTencentAttention,@"我的关注",nil];
        _selectedName = @"最新微博";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //nav
    [self setTitle:@"首页"];
    //导航
    _selectedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_selectedButton setFrame:CGRectMake(60, 0, 200, 44)];
    [_selectedButton setTitle:@"首页" forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(changeWeiboList:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _selectedButton;
    
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

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - loadWeiboData
-(void)loadWeiboData{
    //NSLog(@"selectedname = %@",_selectedName);
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    //获取到当前微博
    NSString *weiboName =[SelectedWeiboName sharedWeiboName].weiboName;
    if ([weiboName isEqualToString:@"新浪微博"]&&[userData objectForKey:@"token"]) {
        //新浪微博
        NSString *sinaUrl = [NSString stringWithFormat:@"%@?&source=%@&access_token=%@",[_listData objectForKey:_selectedName],KSAppKey,[userData objectForKey:@"token"]];
        //请求数据
        [userInfoRequset getUserDataWithUrlStr:sinaUrl];
        __weak typeof(self) weakSelf = self;
        //回调数据处理
        userInfoRequset.block = ^(NSMutableDictionary *dic){
            weakSelf.weiboData = [dic objectForKey:@"statuses"];
            //刷新数据
            [weakSelf.pullTableView reloadData];
        };
    }else if([weiboName isEqualToString:@"腾讯微博"]&&[userData objectForKey:@"tencent_token"]){
        //腾讯微博
        //通用参数oauth_consumer_key&access_token&openid&clientip&oauth_version=2.a&scope=all
        //最新微博参数format=json&pos=0&reqnum=20
        //参数format=json&pageflag=0&pagetime=0&reqnum=20&lastid=0&type=0&contenttype=0
        NSMutableString *tencentUrl = [NSMutableString stringWithFormat:@"%@?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a&type=0&clientip=127.0.0.1&scope=all&reqnum=10",[_tlistData objectForKey:_selectedName],KTAppKey,[userData objectForKey:@"tencent_token"],[userData objectForKey:@"openid"]];
        if ([_selectedName isEqualToString:@"最新微博"]) {
            [tencentUrl appendString:@"&pos=0"];
        }else{
            [tencentUrl appendString:@"&pageflag=0&pagetime=0&lastid=0&type=0&contenttype=0"];
        }
        //请求数据
        [userInfoRequset getUserDataWithUrlStr:tencentUrl];
        //处理回调数据
         __weak typeof(self) weakSelf = self;
        userInfoRequset.block = ^(NSMutableDictionary *dic){
            weakSelf.weiboData = [[dic objectForKey:@"data"]objectForKey:@"info"];
            //刷新数据
            [weakSelf.pullTableView reloadData];
        };
    }
}

#pragma mark - Refresh and load more methods
//下拉刷新事件
- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    [self loadWeiboData];
    
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
    return self.weiboData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.weiboData objectAtIndex:indexPath.row];
    //行高
    int iTop = [weiboCell heightWith:dict WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
    return iTop;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict = [self.weiboData objectAtIndex:indexPath.row];
    weiboCell *cell = [[weiboCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContentData:dict];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //查看详情
    NSLog(@"didSelectRowAtIndexPath----%ld",(long)indexPath.row);
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
    //通知主视图刷新数据
    _block([_Weibolist objectAtIndex:indexPath.row]);
}
@end