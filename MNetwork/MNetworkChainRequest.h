//
//  MNetworkChainRequest.h
//  Memory
//
//  Created by zyx on 16/4/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MNetworkChainRequestSuccessBlock)(void);
typedef void (^MNetworkChainRequestFailureBlock)(MNetworkErrorModel *error);

@protocol MNetworkChainRequestDelegate <NSObject>

@optional

- (void)chainRequestCompleteSuccess;

- (void)chainRequestCompleteFailure;

@end

@interface MNetworkChainRequest : NSObject

/**
 *  有前后关系的请求数组，数组里面可能又是数组或单个请求。
 */
@property (nonatomic, strong) NSArray *requestChainArray;


@property (nonatomic, copy) MNetworkChainRequestSuccessBlock successBlock;


@property (nonatomic, copy) MNetworkChainRequestFailureBlock failureBlock;


@property (nonatomic, weak) id<MNetworkChainRequestDelegate> delegate;

/**
 *  工厂方法
 *
 *  @param array        请求的队列数组
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 *  @param start        是否立即开始
 
 *  @return 返回一个实例对象
 */
+ (instancetype)chainRequestWithArray:(NSArray *)array
                         successBlock:(MNetworkChainRequestSuccessBlock)successBlock
                         failureBlock:(MNetworkChainRequestFailureBlock)failureBlock
                     startImmediately:(BOOL)start;

/**
 *  开始进行网络请求
 */
- (void)start;







@end
