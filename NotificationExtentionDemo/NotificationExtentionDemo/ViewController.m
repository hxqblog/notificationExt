//
//  ViewController.m
//  NotificationExtentionDemo
//
//  Created by hxq on 2021/12/31.
//

#import "ViewController.h"
#import "XQLocalNotificationHelper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeLocationBtn;
@property (nonatomic , assign) BOOL doAdd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (XQNotificationModel*)getModel{
    XQNotificationModel *model = [[XQNotificationModel alloc] init];
    model.title = @"推送标题";
    model.content = @"这是推送的内容，内容随便写什么都可以";
    model.notificationID = [NSUUID UUID].UUIDString;
    model.iconImageURL = @"https://profile.csdnimg.cn/9/C/E/1_hxqblog";
    model.attachImageURL = @"https://profile.csdnimg.cn/9/C/E/1_hxqblog";
    model.vibration = YES;
    model.delayTime = 2;
    model.needSound = YES;
    model.badge = @(arc4random()%10);
    return model;
}

- (IBAction)addLocationClick:(id)sender {
    if (self.doAdd) {
        NSLog(@"正在执行添加操作");
        return;
    }
    self.doAdd = YES;
    __weak typeof(self) weakself = self;
    [XQLocalNotificationHelper addLocalNotification:[self getModel] withCompletionHandler:^(NSError * _Nonnull error) {
        if (error) {
            NSLog(@"通知添加失败");
        }
        weakself.doAdd = NO;
    }];
}

- (IBAction)removeLocationClick:(id)sender {
}
@end
