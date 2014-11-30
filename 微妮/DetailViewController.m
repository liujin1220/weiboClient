//
//  DetailViewController.m
//  微妮
//
//  Created by 刘锦 on 14/11/12.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "DetailViewController.h"
#import "UserInfoData.h"
#import "weiboCell.h"
#import "CommentCell.h"
@interface DetailViewController (){
    UserInfoData *commentRequest;
    //sina
    int page;
    
    //tencent
    ino64_t  twitterid;//最后一条微博评论的id,第一页填0
    int pageflag;//用于翻页（0：第一页，1：向下翻页，2：向上翻页）
    NSInteger pagetime;//(0:第一页)填上一次请求返回的最后一条记录时间
    ino64_t rootid;
}
@property(nonatomic,strong)PullTableView *weiboDetailView;
@property(nonatomic)int64_t weiboID;
@property(nonatomic)int64_t lastid; //最后一条微博评论的id
@property(nonatomic)NSInteger lastTime;//最后一条微博的时间
@property(nonatomic,strong)NSMutableArray *commentArr;
@property(nonatomic)BOOL isLoadMore;
@end

@implementation DetailViewController
-(id)init{
    self = [super init];
    if (self) {
        _singelWeiboData = [NSMutableDictionary dictionary];
        _commentArr = [NSMutableArray array];
        _isLoadMore = NO;
        page = 1;
        
        pagetime = 0;
        pageflag =0;
    }
    return self;
}
- (void)viewDidLoad {
    [self setTitle:@"微博正文"];
    [super viewDidLoad];
    self.weiboDetailView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44) style:UITableViewStyleGrouped];
    self.weiboDetailView.delegate = self;
    self.weiboDetailView.dataSource = self;
    self.weiboDetailView.pullDelegate = self;
    [self.weiboDetailView setSeparatorInset:UIEdgeInsetsMake(15,0,0,15)];
    [self.view addSubview:self.weiboDetailView];
    self.weiboDetailView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.weiboDetailView.pullBackgroundColor = [UIColor whiteColor];
    self.weiboDetailView.pullTextColor = [UIColor blackColor];
    
    //初始化
    commentRequest = [[UserInfoData alloc]init];
    _weiboID = [[_singelWeiboData objectForKey:@"id"] longLongValue];
    rootid = _weiboID;
    if ([[_singelWeiboData objectForKey:@"type"]isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //转发的
        rootid = [[[_singelWeiboData objectForKey:@"source"]objectForKey:@"id"] longLongValue];
    }
    twitterid = 0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.weiboDetailView.pullTableIsRefreshing) {
        self.weiboDetailView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    }
}

- (void)viewDidUnload
{
    [self setWeiboDetailView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - RequestData
//请求数据
-(void)loadComment{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *requestStr;
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        requestStr = [NSString stringWithFormat:@"https://api.weibo.com/2/comments/show.json?access_token=%@&id=%lld&since_id=0&count=3&page=%d",[userData objectForKey:@"token"],_weiboID,page];
        [commentRequest getUserDataWithUrlStr:requestStr];
        //处理回调数据
        __weak typeof(self) weakSelf = self;
        commentRequest.block = ^(NSMutableDictionary *dic){
            //NSLog(@"新浪微博评论列表%@",dic);
            if ([dic objectForKey:@"total_number"]) {
                if (weakSelf.isLoadMore) {
                    //拼接
                    [weakSelf.commentArr addObjectsFromArray:[dic objectForKey:@"comments"]];
                }else{
                    weakSelf.commentArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"comments"]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新UI操作
                    //.....
                    //刷新数据
                    [weakSelf.weiboDetailView reloadData];
                });
            }
        };
    }else{
        //
        requestStr = [NSMutableString stringWithFormat:@"https://open.t.qq.com/api/t/re_list?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a&type=0&clientip=127.0.0.1&scope=all&reqnum=2&flag=2&pageflag=%d&rootid=%lld&twitterid=%lld&pagetime=%ld",KTAppKey,[userData objectForKey:@"tencent_token"],[userData objectForKey:@"openid"],pageflag,rootid,twitterid,(long)pagetime];
        [commentRequest getUserDataWithUrlStr:requestStr];//处理回调数据
        __weak typeof(self) weakSelf = self;
        commentRequest.block = ^(NSDictionary *dic){
            //NSLog(@"腾讯微博评论列表%@",dic);
            if ((NSNull *)[dic objectForKey:@"data"] != [NSNull null] ) {
                if (weakSelf.isLoadMore) {
                    //拼接
                    [weakSelf.commentArr addObjectsFromArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }else{
                    weakSelf.commentArr = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"]objectForKey:@"info"]];
                }
                weakSelf.lastTime = [[[weakSelf.commentArr lastObject]objectForKey:@"timestamp"] integerValue];
                weakSelf.lastid = [[[weakSelf.commentArr lastObject]objectForKey:@"id"] doubleValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
                //.....
                //刷新数据
                [weakSelf.weiboDetailView reloadData];
            });
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
    _isLoadMore = NO;
    page = 1;
    
    pageflag = 1;
    pagetime = 0;
    twitterid = 0;
    
    [self loadComment];
    self.weiboDetailView.pullLastRefreshDate = [NSDate date];
    self.weiboDetailView.pullTableIsRefreshing = NO;
}
//上拉加载更多
- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    page++;
    _isLoadMore = YES;
    
    pageflag = 1;
    pagetime = _lastTime;
    twitterid = _lastid;
    
    [self loadComment];
    self.weiboDetailView.pullTableIsLoadingMore = NO;
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
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int iTop = 44;
    if (indexPath.section == 0) {
        //微博
        iTop = [weiboCell heightWith:self.singelWeiboData WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
    }else{
        //评论
        if ([self.commentArr count]) {
            iTop = [CommentCell heightWith:[_commentArr objectAtIndex:indexPath.row] WithWeiboName:[SelectedWeiboName sharedWeiboName].weiboName];
        }
    }
    return iTop;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //微博
        weiboCell *cell = [[weiboCell alloc]init];
        [cell setContentData:self.singelWeiboData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if ([self.commentArr count]) {
            CommentCell *cell =  [[CommentCell alloc]init];
            [cell setContentData:[self.commentArr objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
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
    //查看详情
    NSLog(@"didSelectRowAtIndexPath----%ld",(long)indexPath.row);
}

@end
