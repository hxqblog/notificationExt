//
//  XQLocalNotificationHelper.h
//  NotificationExtentionDemo
//
//  Created by hxq on 2021/12/31.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN
@class XQNotificationModel;
@interface XQLocalNotificationHelper : NSObject

+ (void)addLocalNotification:(XQNotificationModel*)notificationModel withCompletionHandler:(void(^)(NSError *error))completionHandler;

+ (void)removeLocalNotification:(XQNotificationModel*)notificationModel;

+ (void)handleUserInfo:(NSDictionary*)userInfo;

/*
 添加通知操作按钮
 这个需要通过扩展实现。需将扩展中的info.plist里面的UNNotificationExtensionCategory的值和添加时候的categoryIdentifier一致
 */
+ (void)registerNotificationCategoryAndAction;

+ (void)handleNotificationAction:(UNNotificationResponse *)response;

@end

@interface XQNotificationModel : NSObject

@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *content;
@property (nonatomic , assign)BOOL needSound;
@property (nonatomic , assign)BOOL vibration;//震动
@property (nonatomic , strong)NSNumber *badge;
@property (nonatomic , assign)NSInteger delayTime;
@property (nonatomic , copy)NSString *notificationID;

//userInfo conntent
@property (nonatomic , copy)NSString *attachImageURL;
@property (nonatomic , copy)NSString *iconImageURL;

@end
NS_ASSUME_NONNULL_END
