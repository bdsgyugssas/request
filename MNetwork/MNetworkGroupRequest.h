//
//  MNetworkGroupRequest.h
//  MNetWork
//
//  Created by developer on 16/2/17.
//  Copyright © 2016年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MNetworkBaseRequest,MNetworkGroupRequest;


typedef void (^MNetworkGroupRequestProcessBlock)(float process);
typedef void (^MNetworkGroupRequestSuccessBlock)(void);
typedef void (^MNetworkGroupRequestFailureBlock)(NSArray *failureArray);

@protocol MNetworkGroupRequestDelegate <NSObject>

@optional

- (void)groupRequestCompleteSuccess;

- (void)groupRequestCompleteFailure;

@end

@interface MNetworkGroupRequest : NSObject
/*  请求的数组 **/
@property (nonatomic, strong) NSArray<MNetworkBaseRequest *> *requestArray;

@property (nonatomic, copy) MNetworkGroupRequestSuccessBlock success;

@property (nonatomic, copy) MNetworkGroupRequestFailureBlock failure;

@property (nonatomic, copy) MNetworkGroupRequestProcessBlock processBlock;

@property (nonatomic, weak) id<MNetworkGroupRequestDelegate> delegate;


+ (instancetype)groupRequestWithRequestArray:(NSArray *)requestArray
                                processBlock:(MNetworkGroupRequestProcessBlock)processBlock
                                successBlock:(MNetworkGroupRequestSuccessBlock)successBlock
                                failureBlock:(MNetworkGroupRequestFailureBlock)failureBlock
                              startImmediate:(BOOL)start;

- (void)start;

@end
