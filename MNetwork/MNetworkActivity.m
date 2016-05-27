//
//  MNetworkActivity.m
//  Memory
//
//  Created by zyx on 16/3/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MNetworkActivity.h"
#import <AFNetworking.h>
@implementation MNetworkActivity


+ (MNetworkActivityStatus)currentNetworkStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus status = manager.networkReachabilityStatus;
    
    switch (status) {

        case AFNetworkReachabilityStatusNotReachable: {
            return MNetworkActivityStatusNotReachable;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            return MNetworkActivityStatusReachableViaWWAN;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return MNetworkActivityStatusReachableViaWiFi;
            break;
        }
        case AFNetworkReachabilityStatusUnknown: {
            return MNetworkActivityStatusUnknown;
            break;
        }
    }
}

+ (BOOL)isEnabled
{
    MNetworkActivityStatus status = [self currentNetworkStatus];
    
    switch (status) {
        case MNetworkActivityStatusNotReachable: {
            return NO;
            break;
        }
        case MNetworkActivityStatusUnknown:
        case MNetworkActivityStatusReachableViaWWAN:
        case MNetworkActivityStatusReachableViaWiFi: {
            return YES;
            break;
        }
    }
}


@end
