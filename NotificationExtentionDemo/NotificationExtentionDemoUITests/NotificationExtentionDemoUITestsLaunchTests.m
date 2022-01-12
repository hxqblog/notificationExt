//
//  NotificationExtentionDemoUITestsLaunchTests.m
//  NotificationExtentionDemoUITests
//
//  Created by hxq on 2021/12/31.
//

#import <XCTest/XCTest.h>

@interface NotificationExtentionDemoUITestsLaunchTests : XCTestCase

@end

@implementation NotificationExtentionDemoUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
