//
//  MNetworkChainRequest.m
//  Memory
//
//  Created by zyx on 16/4/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MNetworkChainRequest.h"
#import "MNetworkGroupRequest.h"
#import "MNetworkBaseRequest.h"
#import "MNetworkAgent.h"
@interface MNetworkChainRequest () <MNetworkBaseRequestDelegate, MNetworkGroupRequestDelegate, MNetworkChainRequestDelegate>

@property (nonatomic, assign) NSInteger requestDownNumber;

@end

@implementation MNetworkChainRequest

+ (instancetype)chainRequestWithArray:(NSArray *)array
                         successBlock:(MNetworkChainRequestSuccessBlock)successBlock
                         failureBlock:(MNetworkChainRequestFailureBlock)failureBlock
                     startImmediately:(BOOL)start
{
    MNetworkChainRequest *request = [[MNetworkChainRequest alloc]init];
    
    request.requestChainArray = array;
    request.successBlock = successBlock;
    request.failureBlock = failureBlock;
    request.requestDownNumber = 0;
    
    if (start) {
        [request start];
    }
    
    return request;
}

- (void)start
{
    if (_requestChainArray.count == 0) {
        if (_successBlock) {
            _successBlock();
        }
        
        if ([self.delegate respondsToSelector:@selector(chainRequestCompleteSuccess)]) {
            [self.delegate chainRequestCompleteSuccess];
        }
        
        return;
    }
    
    MNetworkChainAgent *agent = [MNetworkChainAgent shareMNetworkChainAgent];
    [agent addChainRequest:self];
    [self startHandleRequestNumber:_requestDownNumber];
}

#pragma mark - private

- (void)startHandleRequestNumber:(NSInteger)number
{
    id request = _requestChainArray[number];
    
    if ([request isKindOfClass:[MNetworkBaseRequest class]]) {
        
        MNetworkBaseRequest *baseRequest = (MNetworkBaseRequest *)request;
        baseRequest.delegate = self;
        [baseRequest start];

    } else if ([request isKindOfClass:[MNetworkGroupRequest class]]) {
        
        MNetworkGroupRequest *groupReuqest = (MNetworkGroupRequest *)request;
        groupReuqest.delegate = self;
        [groupReuqest start];

    } else if ([request isKindOfClass:[MNetworkChainRequest class]]) {
        
        MNetworkChainRequest *chainRequset = (MNetworkChainRequest *)request;
        chainRequset.delegate = self;
        [chainRequset start];
        
    }
}

- (void)handleOneRequestDown
{
    _requestDownNumber ++;
    
    if (_requestDownNumber < _requestChainArray.count) {
        [self startHandleRequestNumber:_requestDownNumber];
    } else if (_requestDownNumber == _requestChainArray.count) {

        if (_successBlock) {
            _successBlock();
        }
        [[MNetworkChainAgent shareMNetworkChainAgent] removeChainRequest:self];
        _requestDownNumber = 0;
    }
}

- (void)handleOneRequestDownWithError
{
    
}


#pragma mark - MNetworkBaseRequestDelegate

- (void)requestDidFinishSuccess:(MNetworkBaseRequest *)request
{
    [self handleOneRequestDown];
}

- (void)requestDidFinishFailure:(MNetworkBaseRequest *)request
{
    [self handleOneRequestDownWithError];
}

#pragma mark - MNetworkGroupRequestDelegate

- (void)groupRequestCompleteSuccess
{
    [self handleOneRequestDown];
}

- (void)groupRequestCompleteFailure
{
    [self handleOneRequestDownWithError];
}

#pragma mark - MNetworkChainRequestDelegate

- (void)chainRequestCompleteSuccess
{
    [self handleOneRequestDown];
}

- (void)chainRequestCompleteFailure
{
    [self handleOneRequestDownWithError];
}


@end
