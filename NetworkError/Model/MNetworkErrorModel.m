//
//  MNetworkErrorModel.m
//  Memory
//
//  Created by zyx on 16/5/17.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MNetworkErrorModel.h"

@implementation MNetworkErrorModel

+ (instancetype)network404
{
    MNetworkErrorModel *model = [[self alloc]init];
    model.errorCode = 404;
    model.errorDescription = @"无法联网";
    return model;
}

+ (instancetype)errorModelWithErrorCode:(NSInteger)errorCode description:(id)errorDescription
{
    MNetworkErrorModel *model = [[self alloc]init];
    model.errorCode = errorCode;
    model.errorDescription = errorDescription;
    return model;
}

@end
