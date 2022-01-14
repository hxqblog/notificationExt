//
//  NotificationViewController.m
//  XQPushContentExt
//
//  Created by hxq on 2021/12/31.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "HudView.h"

@interface NotificationViewController () <UNNotificationContentExtension>

//@property (strong, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UILabel *titLabel;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

@property (strong, nonatomic)  UIView *contentView;
@property (strong, nonatomic)  UILabel *titLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UIImageView *iconImageView;

@property (strong, nonatomic)  UIImageView *bigImageView;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ui];
    // Do any required interface initialization here.
}

- (void)ui{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 350)];
    self.contentView.center = self.view.center;
    [self.view addSubview:self.contentView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    self.titLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 8, 0, self.contentView.frame.size.width - 76 , 25)];
    [self.contentView addSubview:self.titLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titLabel.frame.origin.x, CGRectGetMaxY(self.titLabel.frame) + 5, self.contentView.frame.size.width - 20, 100)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.contentLabel];
    
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x, CGRectGetMaxY(self.contentLabel.frame) + 8, self.contentLabel.frame.size.width , self.contentView.frame.size.height - CGRectGetMaxY(self.contentLabel.frame) - 18)];
    [self.contentView addSubview:self.bigImageView];
    
}

- (void)didReceiveNotification:(UNNotification *)notification {
    NSDictionary *userInfo = notification.request.content.userInfo;
    self.titLabel.text = notification.request.content.title;
    self.contentLabel.text = notification.request.content.body;
    self.iconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo[@"iconImageURL"]]]];
    self.bigImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo[@"attachImageURL"]]]];
}

@end
