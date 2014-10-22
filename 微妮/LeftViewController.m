//
//  LeftViewController.m
//  微妮
//
//  Created by 刘锦 on 14/10/22.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "LeftViewController.h"
#import "SelectedWeiboName.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:34/255.0  green:54/255.0 blue:66/255.0 alpha:1]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
      // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[SelectedWeiboName sharedWeiboName].weiboArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"我的微博";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"leftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    //cell被选中后的颜色不变
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:[[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:indexPath.row]];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    [cell.imageView setImage:[UIImage imageNamed:@"me_head_default"]];
    return cell;
}

#pragma mark - UITableViewDelegate
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedName = [[SelectedWeiboName sharedWeiboName].weiboArray objectAtIndex:indexPath.row];
    //设置当前微博
    [SelectedWeiboName sharedWeiboName].weiboName = selectedName;
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kWeiboDidChangeNotification object:selectedName];
}
@end
