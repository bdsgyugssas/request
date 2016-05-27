//
//  MNetworkHelper.h
//  Memory
//
//  Created by developer on 16/2/23.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetworkHelper : NSObject

+ (void)analysisResponsedData:(id)responsedData
             WithSuccessBlock:(void(^)(id data))successBlock
                 failureBlock:(void(^)(id errors, NSInteger statusCode))failureBlock;

@end
