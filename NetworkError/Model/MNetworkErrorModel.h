//
//  MNetworkErrorModel.h
//  Memory
//
//  Created by zyx on 16/5/17.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetworkErrorModel : NSObject

@property (nonatomic, assign) NSInteger errorCode;

@property (nonatomic, strong) id errorDescription;

+ (instancetype)network404;

+ (instancetype)errorModelWithErrorCode:(NSInteger)errorCode description:(id)errorDescription;


@end
