//
//  MNetworkGroupRequest.m
//  MNetWork
//
//  Created by developer on 16/2/17.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkGroupRequest.h"
#import "MNetworkAgent.h"
#import "MNetworkBaseRequest.h"
#import "MNetworkDownloadRequest.h"


@interface MNetworkGroupRequest() <MNetworkBaseRequestDelegate>

@property (nonatomic, assign) NSInteger requestTotal;

@property (nonatomic, strong) NSMutableDictionary *requestDict;

@property (nonatomic, strong) NSMutableArray *failureRequestArray;

@end

@implementation MNetworkGroupRequest

- (NSMutableDictionary *)requestDict
{
    if (_requestDict == nil) {
        _requestDict = [NSMutableDictionary new];
    }
    return _requestDict;
}

- (NSMutableArray *)failureRequestArray
{
    if (_failureRequestArray == nil) {
        _failureRequestArray = [NSMutableArray new];
    }
    return _failureRequestArray;
}

#pragma mark -

+ (instancetype)groupRequestWithRequestArray:(NSArray *)requestArray
                                processBlock:(MNetworkGroupRequestProcessBlock)processBlock
                                successBlock:(MNetworkGroupRequestSuccessBlock)successBlock
                                failureBlock:(MNetworkGroupRequestFailureBlock)failureBlock
                              startImmediate:(BOOL)start
{
    MNetworkGroupRequest *request = [[MNetworkGroupRequest alloc]init];
    request.requestArray = requestArray;
    request.success = successBlock;
    request.failure = failureBlock;
    request.processBlock = processBlock;
    
    
    if (start) {
        [request start];
    }
    return request;
}


- (void)start
{
    
    if (_requestArray.count == 0) {
        if (self.processBlock) {
            self.processBlock(1);
        }
        if (_success) {
            _success();
        }
        
        if ([self.delegate respondsToSelector:@selector(groupRequestCompleteSuccess)]) {
            [self.delegate groupRequestCompleteSuccess];
        }
        return;
    }
    
    DLog(@"%ld", _requestArray.count);
    
    MNetworkGroupAgent *groupAgent = [MNetworkGroupAgent shareMNetworkGroupAgent];
    [groupAgent addGroupRequest:self];
    
    if (self.processBlock) {
        self.processBlock(0);
    }
    
    NSInteger totalRequest = _requestArray.count;
    
    for (int i = 0; i < totalRequest; i ++) {
        MNetworkBaseRequest *request = _requestArray[i];
        self.requestDict[@(request.hash)] = @(i);
        request.delegate = self;
        [request start];
    }
    
    
}


#pragma mark - private

- (void)setRequestTotal:(NSInteger)requestTotal
{

    _requestTotal = requestTotal;
    
    if (self.processBlock) {
        float processNum = (float)requestTotal /_requestArray.count;
        self.processBlock(processNum);
    }
    
    
    if (requestTotal == _requestArray.count) {
        
        if (_requestArray.count == 1) {
            
        }
        
        if (self.failureRequestArray.count > 0) {
            
            if (_failure) {
                _failure(self.failureRequestArray);
            }
            if ([self.delegate respondsToSelector:@selector(groupRequestCompleteFailure)]) {
                [self.delegate groupRequestCompleteFailure];
            }
            
        } else {
            if (self.success) {
                self.success();
            }
            if ([self.delegate respondsToSelector:@selector(groupRequestCompleteSuccess)]) {
                [self.delegate groupRequestCompleteSuccess];
            }
        }

        
        [[MNetworkGroupAgent shareMNetworkGroupAgent] removeGroupRequest:self];
       
    }
}

#pragma mark - 

- (void)requestDidFinishSuccess:(MNetworkBaseRequest *)request
{
    self.requestTotal ++;
}

- (void)requestDidFinishFailure:(MNetworkBaseRequest *)request
{
    self.requestTotal ++;
    [self.failureRequestArray addObject:self.requestDict[@(request.hash)]];
}




@end
