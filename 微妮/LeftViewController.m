//
//  LeftViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "LeftViewController.h"
#import "SelectedWeiboName.h"
#import "UserInfoData.h"
#import "AuthorizeViewController.h"
#define kWeiboReLogin @"kWeiboReLogin"
@interface LeftViewController ()
{
    NSUserDefaults *userDefault;
    UserInfoData *user_sina;
    UserInfoData *user_tencent;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:34/255.0  green:54/255.0 blue:66/255.0 alpha:1]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 150, 132) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    
    //退出登录
    UIButton *logOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logOut setFrame:CGRectMake(10, self.view.bounds.size.height - 40, 130, 35)];
    [logOut setBackgroundColor:[UIColor redColor]];
    [logOut setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOut addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOut];
    //加载数据
    user_sina = [[UserInfoData alloc]init];
    user_tencent = [[UserInfoData alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//读数据
-(void)readUserDefault{
    userDefault = [NSUserDefaults standardUserDefaults];
}
#pragma mark - User
//添加账户
-(void)addAction{
    NSString *weiboName;
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        //腾讯微博
        //[_txwbapi loginWithDelegate:self andRootController:self];
        weiboName = @"腾讯微博";
    }else{
        //新浪微博
        weiboName = @"新浪微博";
    }
    AuthorizeViewController *authVC = [[AuthorizeViewController alloc]initWithWeiboName:weiboName];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:authVC];
    [self presentViewController:navC animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    authVC.block = ^(){
        //刷新
        [weakSelf.tableView reloadData];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kWeiboDidChangeNotification object:[SelectedWeiboName sharedWeiboName].weiboName];
    };
}
-(int)findIndexFromArray:(NSMutableArray *)array WithString:(NSString *)string{
    int index = 0;
    for (int i = 0; i<array.count; i++) {
        if ([[NSString stringWithFormat:@"%@",[array objectAtIndex:i]] isEqualToString:string]) {
            index = i;
        }
    }
    return index;
}
//删除账户
-(void)logOutAction{
    [self readUserDefault];
    //退出
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        [userDefault removeObjectForKey:@"token"];
        [userDefault removeObjectForKey:@"uid"];
    }else{
        [userDefault removeObjectForKey:@"tencent_token"];
        [userDefault removeObjectForKey:@"openid"];
        [userDefault removeObjectForKey:@"refresh_token"];
    }
    int i =  [self findIndexFromArray:[SelectedWeiboName sharedWeiboName].weiboArray WithString:[SelectedWeiboName sharedWeiboName].weiboName];
    [[SelectedWeiboName sharedWeiboName].weiboArray removeObjectAtIndex:i];
    [self loginInfomation];
}

//判断当前登陆情况
-(void)loginInfomation{
    if ([SelectedWeiboName sharedWeiboName].weiboArray == nil||[SelectedWeiboName sharedWeiboName].weiboArray.count == 0) {
        //返回主页面
        NSLog(@"返回主页面");
        [[NSNotificationCenter defaultCenter]postNotificationName:kWeiboReLogin object:[SelectedWeiboName sharedWeiboName].weiboName];
    }else{
        //切换当前微博
        [SelectedWeiboName sharedWeiboName].weiboName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:0];
        //刷新视图
        [self.tableView reloadData];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kWeiboDidChangeNotification object:[SelectedWeiboName sharedWeiboName].weiboName];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[SelectedWeiboName sharedWeiboName].weiboArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self readUserDefault];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSString *text = [NSString stringWithFormat:@"%@",[[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:[[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:indexPath.row]];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    if ([text isEqualToString:@"新浪微博"]) {
        NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",[userDefault objectForKey:@"token"],[userDefault objectForKey:@"uid"]];
        [user_sina getUserDataWithUrlStr:url];
        user_sina.block = ^(NSMutableDictionary *dic){
            cell.textLabel.text = [dic objectForKey:@"screen_name"];
            NSString *photoStr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"profile_image_url"]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:@"me_head_default"]];
        };
    }else{
        NSString *tencentUrl = [NSString stringWithFormat:@"http://open.t.qq.com/api/user/info?format=json&oauth_consumer_key=%@&access_token=%@&openid=%@&oauth_version=2.a&type=0&clientip=127.0.0.1&scope=all",KTAppKey,[userDefault objectForKey:@"tencent_token"],[userDefault objectForKey:@"openid"]];
        [user_tencent getUserDataWithUrlStr:tencentUrl];
        user_tencent.block = ^(NSMutableDictionary *dic){
            cell.textLabel.text = [[dic objectForKey:@"data"]objectForKey:@"nick"];
            NSString *tphotoStr =[NSString stringWithFormat:@"%@/50",[[dic objectForKey:@"data"]objectForKey:@"head"]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:tphotoStr] placeholderImage:[UIImage imageNamed:@"me_head_default"]];
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    //myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 90, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [titleLabel setText:@"我的微博"];
    [myView addSubview:titleLabel];
    return myView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //footerview
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(0, 0, 130, 44)];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    return addButton;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:indexPath.row];
    //设置当前微博
    [SelectedWeiboName sharedWeiboName].weiboName = selectedName;
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kWeiboDidChangeNotification object:selectedName];
}
@end
