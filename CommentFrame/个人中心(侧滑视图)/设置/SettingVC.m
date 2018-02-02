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
	weakObj;
	[BaseServer postObjc:nil path:@"/user/contact/tel" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
		dispatch_async(dispatch_get_main_queue(), ^{
			strongSelf.companyPhoneLbl.text = result[@"data"][@"company"];
			strongSelf.complaintPhoneLbl.text = result[@"data"][@"complait"];
		});
	} failed:^(NSError *error) {
		
	}];
	 self.tableView.backgroundColor = UIColorFromHX(0xf0f0f0);
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
        return 10;
    }
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
