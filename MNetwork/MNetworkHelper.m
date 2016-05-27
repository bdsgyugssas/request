//
//  MNetworkHelper.m
//  Memory
//
//  Created by developer on 16/2/23.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MNetworkHelper.h"

@implementation MNetworkHelper

+ (void)analysisResponsedData:(id)responsedData WithSuccessBlock:(void (^)(id))successBlock failureBlock:(void (^)(id, NSInteger))failureBlock
{
    NSInteger code = [responsedData[@"status"] integerValue];
    if (code >= 200 && code <= 299) {
        if (successBlock) {
            successBlock(responsedData[@"data"]);
        }
    }else{
        if (failureBlock) {
            failureBlock(responsedData[@"errors"], code);
        }
    }
}

@end
