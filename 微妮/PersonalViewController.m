//
//  PersonalViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "PersonalViewController.h"
#import "WeiboCell.h"
#import "BaseRequest.h"
#import "DetailViewController.h"
#import "PersonalModel.h"

#define kSinaUserInfoURL        @"https://api.weibo.com/2/users/show.json?"
#define kHeadViewHeight         180

@interface PersonalViewController ()
@property (nonatomic, strong) BaseRequest *userInfoRequest;
@property (nonatomic, strong) PersonalModel *personaModel;

@property (nonatomic, strong) PersonalHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *userPhotoView;

@property (nonatomic, strong) NSArray *baseInfo;
@property (nonatomic, strong) NSArray *contactInfo;
@property (nonatomic, strong) NSArray *baseInfoData;
@property (nonatomic, strong) NSArray *contactInfoData;

@end

@implementation PersonalViewController

#pragma mark - lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我"];
    
    self.headerView.buttonActionDelegate = self;
    self.baseInfo = @[@"性别",@"所在地",@"描述",@"是否加V用户"];
    self.contactInfo = @[@"关注",@"粉丝",@"互粉数",@"微博数"];
    
    // tableview
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    // headerView
    self.headerView = [[PersonalHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeadViewHeight)];
    [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    [self.tableview setTableHeaderView:_headerView];
    
    self.personaModel = [[PersonalModel alloc]init];
    [self downLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DownLoadData

- (void)downLoadData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *requestString;
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        requestString = [NSString stringWithFormat:@"%@access_token=%@&uid=%@",kSinaUserInfoURL,[userDefault objectForKey:@"token"],[userDefault objectForKey:@"uid"]];
    }else {
        requestString = [NSString stringWithFormat:@"tencent"];
    }
    self.userInfoRequest = [[BaseRequest alloc]initWithURL:requestString];
    __weak typeof(self) weakSelf = self;
    [self.userInfoRequest GETRequestWithCompletionHandler:^(NSDictionary *dic) {
        if (![dic isKindOfClass:[NSNull class]]) {
            [weakSelf.personaModel setContentData:dic];
        }
        
        weakSelf.baseInfoData = @[_personaModel.gender,_personaModel.location,_personaModel.descripition,_personaModel.isVerified];
        weakSelf.contactInfoData = @[_personaModel.attentionCount,_personaModel.followersCount,_personaModel.biFollowerscount,_personaModel.weiboCount];
         dispatch_async(dispatch_get_main_queue(), ^{
             // 刷新数据
             [weakSelf.headerView setContentDataWithUserModel:_personaModel];
             [weakSelf.tableview reloadData];
         });
    }];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"userInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    if (indexPath.section == 0) {
        [cell.textLabel setText:[_baseInfo objectAtIndex:indexPath.row]];
        if (nil != _baseInfoData) {
             [cell.detailTextLabel setText:[_baseInfoData objectAtIndex:indexPath.row]];
        }
    }else {
        [cell.textLabel setText:[_contactInfo objectAtIndex:indexPath.row]];
        if (nil != _contactInfoData) {
            [cell.detailTextLabel setText:[_contactInfoData objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma ButtonAction

- (void)buttonActions:(UIButton *)button {
    switch (button.tag) {
        case 1001:
        {
           // 关注
        }
            break;
        case 1002:
        {
            // 粉丝
        }
            break;
        case 1003:
        {
            // 信息
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - NSNotifiction actions
// 当切换主题时会调用
-(void)weiboNotification:(NSNotification *)notification{
//    NSLog(@"person切换主题");
    //请求数据
}

@end
