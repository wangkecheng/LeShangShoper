//
//  SettingVC.m
//  ChatDemo-UI3.0
//
//  Created by warron on 2017/8/2.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "SettingVC.h"
#import "SDImageCache.h"
 #import "FeedBackVC.h"
@interface SettingVC ()

@property (strong, nonatomic)UserInfoModel *userModel;
@property (weak, nonatomic) IBOutlet UILabel *companyPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *complaintPhoneLbl;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
	 self.title = @"设置";
	 self.tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
	[self.tableView hideSurplusLine];
    _userModel = [CacheTool getUserModel]; 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
     UIViewController *VC = nil;
    if (indexPath.section == 0) {
		
        if (indexPath.row == 0) {//公司电话
			 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_companyPhoneLbl.text]]];
        }
    }
	else  if (indexPath.section == 1) {
		if (indexPath.row == 0) {// 投诉电话
			 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_complaintPhoneLbl.text]]];
		}
		if (indexPath.row == 1) {//意见反馈
			FeedBackVC * feedBackVC = [DDFactory getVCById:@"FeedBackVC"];
			VC = feedBackVC;
		}
	}
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
