//
//  MNetworkBaseRequest.h
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MRequestMethod) {//暂时只需要这两种
    MRequestMethodGet,
    MRequestMethodPost,
    MRequestMethodDelete
};

typedef NS_ENUM(NSInteger, MRequestType) {//请求类型
    MRequestTypeNormal = 0, //默认请求
    MRequestTypeDownload //下载
};


/*  成功的回调 **/
typedef void (^MRequestSuccessBlock)(id responseData);
/*  失败的回调 **/
typedef void (^MRequestFailureBlock)(MNetworkErrorModel *model);


@class MNetworkBaseRequest;
@protocol MNetworkBaseRequestDelegate <NSObject>
@optional
- (void)requestDidFinishSuccess:(MNetworkBaseRequest *)request;

- (void)requestDidFinishFailure:(MNetworkBaseRequest *)request withError:(MNetworkErrorModel *)error;

@end

@interface MNetworkBaseRequest : NSObject

@property (nonatomic, weak) id<MNetworkBaseRequestDelegate> delegate;

@property (nonatomic, copy) NSString *url;
/*  请求的url= baseurl/CDNUrl + detailurl**/
@property (nonatomic, copy) NSString *detailurl;

/*  请求头 **/
@property (nonatomic, strong) NSDictionary *requestHeader;
/*  请求参数 **/
@property (nonatomic, strong) NSDictionary *parameter;
/*  超时时间 **/
@property (nonatomic, assign) NSInteger timeoutInterval;
/*  请求方法 **/
@property (nonatomic, assign) MRequestMethod requestMethod;
/*  请求类型 **/
@property (nonatomic, assign) MRequestType requestType;


@property (nonatomic, strong) NSURLSessionTask *sessionTask;
/*  响应码 **/
@property (nonatomic, assign) NSInteger responseStatusCode;
/*  返回的数据 **/
@property (nonatomic, strong) id responseObject;
/*  请求失败的回调 **/
@property (nonatomic, copy) MRequestFailureBlock failureBlock;
/*  请求成功的回调 **/
@property (nonatomic, copy) MRequestSuccessBlock successBlock;


+ (instancetype)requestWithDetailUrl:(NSString *)detailUrl
                              Method:(MRequestMethod)method
                        MrequestType:(MRequestType)type
                       RequestHeader:(NSDictionary *)requestHeader
                           Parameter:(NSDictionary *)parameter;

+ (instancetype)requestWithDetailUrl:(NSString *)detailUrl
                              Method:(MRequestMethod)method
                           Parameter:(NSDictionary *)parameter;

- (instancetype)initWithDetailUrl:(NSString *)detailUrl
                           Method:(MRequestMethod)method
                        Parameter:(NSDictionary *)parameter;

- (instancetype)initWithDetailUrl:(NSString *)detailUrl
                           Method:(MRequestMethod)method
                     MrequestType:(MRequestType)type
                    RequestHeader:(NSDictionary *)requestHeader
                        Parameter:(NSDictionary *)parameter;


/**
 *  开始进行求请求
 */
- (void)start;
/**
 *  暂停请求
 */
- (void)stop;
/**
 *  取消请求
 */
- (void)cancel;
/**
 *  设置请求成功失败的回调
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)startWithCompleteBlockSuccess:(MRequestSuccessBlock)success
                              failure:(MRequestFailureBlock)failure
                          immediately:(BOOL)immdiately;





@end
