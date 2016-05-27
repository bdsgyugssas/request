//
//  MNetworkConfig.m
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkConfig.h"

@implementation MNetworkConfig

static id sharedInstance = nil;

+ (instancetype)shareMNetworkConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

@end
