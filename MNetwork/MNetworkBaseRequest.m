//
//  MNetworkBaseRequest.m
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkBaseRequest.h"
#import "MNetworkAgent.h"
#import "MNetworkActivity.h"
@implementation MNetworkBaseRequest

//- (instancetype)init
//{
//    NSAssert(0, @"该方法不可采用，请采用实现方法");
//    return nil;
//}

- (instancetype)initWithDetailUrl:(NSString *)detailUrl Method:(MRequestMethod)method Parameter:(NSDictionary *)parameter
{
   return [self initWithDetailUrl:detailUrl Method:method MrequestType:MRequestTypeNormal RequestHeader:nil Parameter:parameter];
}

+ (instancetype)requestWithDetailUrl:(NSString *)detailUrl Method:(MRequestMethod)method Parameter:(NSDictionary *)parameter
{
    return [[self alloc]initWithDetailUrl:detailUrl Method:method MrequestType:MRequestTypeNormal RequestHeader:nil Parameter:parameter];

}

+ (instancetype)requestWithDetailUrl:(NSString *)detailUrl Method:(MRequestMethod)method MrequestType:(MRequestType)type RequestHeader:(NSDictionary *)requestHeader Parameter:(NSDictionary *)parameter
{
    return [[self alloc]initWithDetailUrl:detailUrl Method:method MrequestType:type RequestHeader:requestHeader Parameter:parameter];
}

- (instancetype)initWithDetailUrl:(NSString *)detailUrl Method:(MRequestMethod)method MrequestType:(MRequestType)type RequestHeader:(NSDictionary *)requestHeader Parameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        self.detailurl = detailUrl;
        self.requestMethod = method;
        self.requestType = type;
        self.requestHeader = requestHeader;
        self.parameter = parameter;
    }
    return self;
}

- (void)startWithCompleteBlockSuccess:(MRequestSuccessBlock)success failure:(MRequestFailureBlock)failure immediately:(BOOL)immediately
{
    self.successBlock = success;
    self.failureBlock = failure;
    if (immediately) {
        [self start];
    }
}



- (void)start
{
    if (![MNetworkActivity isEnabled]) {
        if (_failureBlock) {
            _failureBlock([MNetworkErrorModel network404]);
        }
        return;
    }
    [[MNetworkAgent shareMNetworkAgent] addRequest:self];
}

- (void)cancel
{
    
}

- (void)stop
{
    
}


- (NSInteger)responseStatusCode
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.sessionTask.response;
    return response.statusCode;
}
@end
