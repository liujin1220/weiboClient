//
//  DetailViewController.m
//  微妮
//
//  Created by 刘锦 on 14/11/12.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "DetailViewController.h"
#import "UserInfoData.h"
#import "WeiboCell.h"
#import "CommentCell.h"
@interface DetailViewController (){
    UserInfoData *commentRequest;
    // sina
    int page;   // 页数
    
    // tencent
    ino64_t     twitterid;  //最后一条微博评论的id,第一页填0
    int         pageflag;   //用于翻页（0：第一页，1：向下翻页，2：向上翻页）
    NSInteger   pagetime;   //(0:第一页)填上一次请求返回的最后一条记录时间
    ino64_t     rootid;     // 根id
}

@property (nonatomic, strong) UITableView       *weiboDetailView;   // 详情视图
@property (nonatomic, strong) NSMutableArray    *commentArr;        // 评论列表
@property (nonatomic) int64_t   weiboID;    // 微博id
@property (nonatomic) int64_t   lastid;     // 最后一条微博评论的id
@property (nonatomic) NSInteger lastTime;   // 最后一条微博的时间
@property (nonatomic) BOOL      isLoadMore; // 是否加载更多

@end

@implementation DetailViewController

#pragma mark - LifeCircle

-(id)init{
    self = [super init];
    if (self) {
        _singelWeiboData    = [NSMutableDictionary dictionary];
        _commentArr         = [NSMutableArray array];
        _isLoadMore         = NO;
        page = 1;
        
        pagetime = 0;
        pageflag = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [self setTitle:@"微博正文"];
    [super viewDidLoad];
    self.weiboDetailView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.weiboDetailView.delegate = self;
    self.weiboDetailView.dataSource = self;
    [self.weiboDetailView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    [self.view addSubview:self.weiboDetailView];
    [self setupRefresh];
    // 初始化
    commentRequest = [[UserInfoData alloc]init];
    _weiboID = [[_singelWeiboData objectForKey:@"id"] longLongValue];
    rootid = _weiboID;
    if ([[_singelWeiboData objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
        // 转发的
        rootid = [[[_singelWeiboData objectForKey:@"source"]objectForKey:@"id"] longLongValue];
    }
    twitterid = 0;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self headerRereshing];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.weiboDetailView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.weiboDetailView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - RequestData
/**
 *  请求数据
 */
-(void)loadComment{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *requestStr;
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        requestStr = [NSString stringWithFormat:@"https://api.weibo.com/2/comments/show.json?access_token=%@&id=%lld&since_id=0&count=3&page=%d",[userData objectForKey:@"token"],_weiboID,page];
        [commentRequest getUserDataWithUrlStr:requestStr];
        // 处理回调数据
        __weak typeof(self) weakSelf = self;
        commentRequest.block = ^(NSMutableDictionary *dic) {
            if ([dic objectForKey:@"total_number"]) {
                if (weakSelf.isLoadMore) {
                    // 拼接
                    [weakSelf.commentArr addObjectsFromArray:[dic objectForKey:@"comments"]];
                }else{
                    weakSelf.commentArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"comments"]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新数据
                    [weakSelf.weiboDetailView reloadData];
                    if (!weakSelf.isLoadMore) {
                        // 滚动到首行
                        [weakSelf.weiboDetailView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    }
                });
            }
        };
    }else {
        requestStr = [NSMutableString stringWithFormat:@"https://open.t.qq.com/api/t/re_list?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a&type=0&clientip=127.0.0.1&scope=all&reqnum=2&flag=2&pageflag=%d&rootid=%lld&twitterid=%lld&pagetime=%ld",kTAppKey,[userData objectForKey:@"tencent_token"],[userData objectForKey:@"openid"],pageflag,rootid,twitterid,(long)pagetime];
        [commentRequest getUserDataWithUrlStr:requestStr];//处理回调数据
        __weak typeof(self) weakSelf = self;
        commentRequest.block = ^(NSDictionary *dic){
            if ((NSNull *)[dic objectForKey:@"data"] != [NSNull null] ) {
                if (weakSelf.isLoadMore) {
                    // 拼接
                    [weakSelf.commentArr addObjectsFromArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }else{
                    weakSelf.commentArr = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }
                weakSelf.lastTime = [[[weakSelf.commentArr lastObject]objectForKey:@"timestamp"] integerValue];
                weakSelf.lastid = [[[weakSelf.commentArr lastObject]objectForKey:@"id"] doubleValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新数据
                [weakSelf.weiboDetailView reloadData];
            });
        };

    }
}
#pragma mark - Refresh and load more methods
//下拉刷新事件
- (void) headerRereshing
{
    /*
     
     Code to actually refresh goes here.
     
     */
    _isLoadMore = NO;
    page        = 1;
    
    pageflag    = 1;
    pagetime    = 0;
    twitterid   = 0;
    
    [self loadComment];
    [self.weiboDetailView headerEndRefreshing];
}
//上拉加载更多
- (void) footerRereshing
{
    /*
     
     Code to actually load more data goes here.
     
     */
    page++;
    _isLoadMore = YES;
    
    pageflag    = 1;
    pagetime    = _lastTime;
    twitterid   = _lastid;
    
    [self loadComment];
    [self.weiboDetailView footerEndRefreshing];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    if ((section == 1)&&([self.commentArr count] != 0)) {
        rows = self.commentArr.count;
    }
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int iTop = 44;
    if (indexPath.section == 0) {
        // 微博
        iTop = [WeiboCell heightWith:self.singelWeiboData WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
    }else{
        // 评论
        if ([self.commentArr count]) {
            iTop = [CommentCell heightWith:[_commentArr objectAtIndex:indexPath.row] WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
        }
    }
    return iTop;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 微博
        WeiboCell *cell = [[WeiboCell alloc]init];
        [cell setContentData:self.singelWeiboData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if ([self.commentArr count]) {
            CommentCell *cell =  [[CommentCell alloc]init];
            [cell setContentData:[self.commentArr objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"该微博暂时没有评论%>_<%";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = @"微博内容";
    if (section == 1) {
        label.text = @"评论";
    }
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 查看详情
    NSLog(@"didSelectRowAtIndexPath----%ld",(long)indexPath.row);
}

@end
