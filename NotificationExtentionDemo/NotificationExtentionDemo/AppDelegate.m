//
//  AppDelegate.m
//  NotificationExtentionDemo
//
//  Created by hxq on 2021/12/31.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "XQLocalNotificationHelper.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerNotification];
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"applicationIconBadgeNumber" options:NSKeyValueObservingOptionNew context:nil];
    return YES;
}

- (void)registerNotification
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            center.delegate = self;
            [XQLocalNotificationHelper registerNotificationCategoryAndAction];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //devicetoken处理后上传后台 用以apns推送
}



#pragma mark UNUserNotificationCenterDelegate

//前台接受推送消息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"present前，current==%@ notibadge==%@",@([UIApplication sharedApplication].applicationIconBadgeNumber),notification.request.content.badge);
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    [self saveBadge];
    
}

//点击推送消息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [XQLocalNotificationHelper handleNotificationAction:response];
    completionHandler();
}

static  NSString* kBadgeUserDefault = @"kBadgeUserDefault";

- (void)saveBadge
{
    NSLog(@"saveBadge，current==%@ ",@([UIApplication sharedApplication].applicationIconBadgeNumber));
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger currentBadge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [def setObject:@(currentBadge) forKey:kBadgeUserDefault];
    [def synchronize];
}
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(applicationIconBadgeNumber))]
        && object == [UIApplication sharedApplication]) {
        
        [self saveBadge];
    }
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
