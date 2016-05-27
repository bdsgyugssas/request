//
//  MNetworkActivity.h
//  Memory
//
//  Created by zyx on 16/3/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNetworkActivityStatus) {
    MNetworkActivityStatusUnknown          = -1,
    MNetworkActivityStatusNotReachable     = 0,
    MNetworkActivityStatusReachableViaWWAN = 1,
    MNetworkActivityStatusReachableViaWiFi = 2,
};

@interface MNetworkActivity : NSObject


+ (MNetworkActivityStatus)currentNetworkStatus;

/**
 *  判断网络是否可行
 *
 */
+ (BOOL)isEnabled;



@end
