//
//  AppDelegate.m
//  HybridDemo
//
//  Created by liweiqiang on 2018/3/19.
//  Copyright © 2018年 TendCloud. All rights reserved.
//

#import "AppDelegate.h"
#import "TalkingDataSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TalkingDataSDK init:@"" channelId:@"AppStore" custom:nil];
    return YES;
}

@end
