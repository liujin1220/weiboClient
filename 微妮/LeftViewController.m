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

@interface LeftViewController ()
{
    NSUserDefaults *userDefault;
    UserInfoData *user_sina;
    UserInfoData *user_tencent;
}
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
    //腾讯微博初始化
    if(self.txwbapi == nil)
    {
        self.txwbapi = [[WeiboApi alloc]initWithAppKey:KTAppKey andSecret:KTAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
    
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
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
        //腾讯微博
         [_txwbapi loginWithDelegate:self andRootController:self];
    }else{
        //新浪微博
        AuthorizeViewController *authVC = [[AuthorizeViewController alloc]init];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:authVC];
        [self presentViewController:navC animated:YES completion:nil];
        authVC.block = ^(){
            //shuxin
            [self addSuccess];
        };
    }
}
-(void)addSuccess{
    NSLog(@"添加完成");
    //刷新视图
    [self.tableView reloadData];
}
//删除账户
-(void)logOutAction{
    [self readUserDefault];
    //退出
    if ([[SelectedWeiboName sharedWeiboName].weiboName isEqualToString:@"新浪微博"]) {
//        NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/account/end_session.json?access_token=%@",[userDefault objectForKey:@"token"]];
//        UserInfoData *user = [[UserInfoData alloc]init];
//        [user getUserDataWithUrlStr:url];
        [userDefault removeObjectForKey:@"token"];
        [userDefault removeObjectForKey:@"uid"];
    }else{
        //
        [self.txwbapi cancelAuth];
    }
    int i =  [self findIndexFromArray:[SelectedWeiboName sharedWeiboName].weiboArray WithString:[SelectedWeiboName sharedWeiboName].weiboName];
    //删除
    [[SelectedWeiboName sharedWeiboName].weiboArray removeObjectAtIndex:i];
    //刷新视图
    [self.tableView reloadData];
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
    [cell.imageView setImage:[UIImage imageNamed:@"me_head_default"]];
    if ([text isEqualToString:@"新浪微博"]) {
        
        NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",[userDefault objectForKey:@"token"],[userDefault objectForKey:@"uid"]];
        [user_sina getUserDataWithUrlStr:url];
        user_sina.block = ^(NSMutableDictionary *dic){
            cell.textLabel.text = [dic objectForKey:@"screen_name"];
            NSString *photoStr =[NSString stringWithFormat:@"%@",[dic objectForKey:@"profile_image_url"]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:photoStr]];
        };
    }else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                       KTAppKey,@"oauth_consumer_key",
                                       [userDefault objectForKey:@"tencentToken"], @"access_token",
                                       [userDefault objectForKey:@"tencentUid"], @"openid",
                                       @"2.a", @"oauth_version",
                                       @"0", @"type",
                                       @"127.0.0.1", @"clientip",
                                       @"all",@"scope", nil];
        
        [user_tencent getUserDataWithParams:params AndApi:@"user/info?"];
        user_tencent.block = ^(NSMutableDictionary *dic){
            cell.textLabel.text = [[dic objectForKey:@"data"]objectForKey:@"nick"];
            NSString *photoStr =[NSString stringWithFormat:@"%@/50",[[dic objectForKey:@"data"]objectForKey:@"head"]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:photoStr]];
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
#pragma mark WeiboAuthDelegate
/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    //NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    //NSLog(@"result = %@",str);
    //设置当前微博
    [[SelectedWeiboName sharedWeiboName].weiboArray addObject:@"腾讯微博"];
    [SelectedWeiboName sharedWeiboName].weiboName = @"腾讯微博";
    //保存
    NSUserDefaults *tencentData = [NSUserDefaults standardUserDefaults];
    [tencentData setObject:wbobj.accessToken forKey:@"tencentToken"];
    [tencentData setObject:wbobj.openid forKey:@"tencentUid"];
    //同步到磁盘
    [tencentData synchronize];
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //添加完成
        [self addSuccess];
    });
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    NSLog(@"%@",str);
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

@end
