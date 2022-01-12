//
//  XQLocalNotificationHelper.m
//  NotificationExtentionDemo
//
//  Created by hxq on 2021/12/31.
//

#import "XQLocalNotificationHelper.h"
#import <AudioToolbox/AudioToolbox.h>

#define myCategoryIdentifier @"notification_action_category"

static const NSString *attachImageURLKey = @"attachImageURL";
static const NSString *iconImageURLKey = @"iconImageURL";
static const NSString *vibrationKey = @"vibration";
static const NSString *needSoundKey = @"needSound";

@implementation XQLocalNotificationHelper

+ (void)addLocalNotification:(XQNotificationModel*)notificationModel withCompletionHandler:(void(^)(NSError *error))completionHandler
{
    if (notificationModel.title.length < 1) {
        return;
    }
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
            NSLog(@"用户拒绝权限");
            return;
        }
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = notificationModel.title;
        content.body = notificationModel.content;
        content.badge = notificationModel.badge;
        content.categoryIdentifier = myCategoryIdentifier;//一定要设置这个 且和info一致才有效果
        if (notificationModel.needSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (notificationModel.attachImageURL) {
            [userInfo setObject:notificationModel.attachImageURL forKey:attachImageURLKey];
        }
        if (notificationModel.iconImageURL) {
            [userInfo setObject:notificationModel.iconImageURL forKey:iconImageURLKey];
        }
        if (notificationModel.vibration) {
            [userInfo setObject:@(1) forKey:vibrationKey];
        }
        
        content.userInfo = userInfo;
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:notificationModel.delayTime repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationModel.notificationID?notificationModel.notificationID:[NSUUID UUID].UUIDString content:content trigger:trigger];
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    
            completionHandler(error);
        }];
    }];
}

+ (void)removeLocalNotification:(XQNotificationModel*)notificationModel 
{
    if (notificationModel.notificationID.length < 1) {
        return;
    }
    //移除未执行的通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            if ([request.identifier isEqualToString:notificationModel.notificationID]) {
                [center removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
            }
        }
    }];
   
}

+ (void)handleUserInfo:(NSDictionary*)userInfo
{
    
    if ([userInfo objectForKey:vibrationKey]) {
    //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

+ (void)registerNotificationCategoryAndAction
{
    
    if (@available(iOS 15.0, *)) {
        // ios 15还可以设置图标
        UNNotificationActionIcon *shareIcon = [UNNotificationActionIcon iconWithSystemImageName:@"square.and.arrow.up"];
        UNNotificationActionIcon *collectIcon = [UNNotificationActionIcon iconWithSystemImageName:@"heart.circle"];
        UNNotificationActionIcon *replayIcon = [UNNotificationActionIcon iconWithSystemImageName:@"keyboard.badge.ellipsis"];
        UNNotificationAction *shareAction = [UNNotificationAction actionWithIdentifier:@"action_share" title:@"分享" options:UNNotificationActionOptionAuthenticationRequired icon:shareIcon];
        UNNotificationAction *collectAction = [UNNotificationAction actionWithIdentifier:@"action_collect" title:@"收藏" options:UNNotificationActionOptionAuthenticationRequired icon:collectIcon];
        UNTextInputNotificationAction *replayAction = [ UNTextInputNotificationAction actionWithIdentifier:@"action_replay" title:@"回复" options:UNNotificationActionOptionAuthenticationRequired icon:replayIcon];
        UNNotificationCategory *shareCollectCategory = [UNNotificationCategory categoryWithIdentifier:myCategoryIdentifier actions:@[shareAction,collectAction,replayAction] intentIdentifiers:@[] options: UNNotificationCategoryOptionCustomDismissAction];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[[NSSet alloc] initWithObjects:shareCollectCategory, nil] ];
        
    }else{
        UNNotificationAction *shareAction = [UNNotificationAction actionWithIdentifier:@"action_share" title:@"分享" options:UNNotificationActionOptionAuthenticationRequired];
        UNNotificationAction *collectAction = [UNNotificationAction actionWithIdentifier:@"action_collect" title:@"收藏" options:UNNotificationActionOptionAuthenticationRequired];
        //文本形式
        UNTextInputNotificationAction *replayAction = [ UNTextInputNotificationAction actionWithIdentifier:@"action_replay" title:@"回复" options:UNNotificationActionOptionAuthenticationRequired];
        UNNotificationCategory *shareCollectCategory = [UNNotificationCategory categoryWithIdentifier:myCategoryIdentifier actions:@[shareAction,collectAction,replayAction] intentIdentifiers:@[] options: UNNotificationCategoryOptionCustomDismissAction];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[[NSSet alloc] initWithObjects:shareCollectCategory, nil] ];
    }
}

+ (void)handleNotificationAction:(UNNotificationResponse *)response
{
    if (![response.notification.request.content.categoryIdentifier isEqualToString:myCategoryIdentifier]) {
        return;
    }
    NSString *idtif = response.actionIdentifier;
    if ([idtif isEqualToString:@"action_share"]) {
        
    }else if ([idtif isEqualToString:@"action_collect"]){
        
    }else if([idtif isEqualToString:@"action_replay"]){
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
        NSString *userText = textResponse.userText;
        NSLog(@"回复被点击了，回复信息===%@",userText);
    }else{
        
    }
    NSLog(@"后台通知点开行为===%@",idtif);
}

@end

@implementation XQNotificationModel

@end
