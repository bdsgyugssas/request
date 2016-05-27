//
//  MNetworkAgent.h
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNetworkBaseRequest, MNetworkGroupRequest, MNetworkChainRequest;

@interface MNetworkAgent : NSObject

+ (instancetype)shareMNetworkAgent;

- (void)addRequest:(MNetworkBaseRequest *)request;

@end

@interface MNetworkGroupAgent : NSObject

+ (instancetype)shareMNetworkGroupAgent;

- (void)addGroupRequest:(MNetworkGroupRequest *)request;

- (void)removeGroupRequest:(MNetworkGroupRequest *)request;
@end


@interface MNetworkChainAgent : NSObject

+ (instancetype)shareMNetworkChainAgent;

/**
 *  将请求存到set中，防止提前释放
 *
 */
- (void)addChainRequest:(MNetworkChainRequest *)request;

/**
 *  请求完成，释放request
 *
 */
- (void)removeChainRequest:(MNetworkChainRequest *)request;

@end

