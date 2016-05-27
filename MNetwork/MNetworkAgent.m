//
//  MNetworkAgent.m
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkAgent.h"
#import <AFNetworking/AFNetworking.h>
#import "AFImageDownloader.h"

#import "MNetworkBaseRequest.h"
#import "MNetworkConfig.h"
#import "MNetworkDownloadRequest.h"
#import "MNetworkHelper.h"
#import "MNetworkBackgroundDownloadRequest.h"
#import "MNetworkChainRequest.h"
#import "MNetworkGroupRequest.h"
#import "MMemoryCache.h"

@interface MNetworkAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) MNetworkConfig *netWorkConfig;

@property (nonatomic, strong) NSMutableDictionary *requestRecord;

@property (nonatomic, strong) NSMutableDictionary *downloadRequestRecord;


@property (nonatomic, strong) MMemoryCache *memoryCache;


/*  缓存 **/
@property (nonatomic, strong) NSCache *downloadCache;


@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation MNetworkAgent


static id sharedInstance = nil;

+ (instancetype)shareMNetworkAgent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *congfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:congfiguration];
        
        _manager = manager;
        
        AFCompoundResponseSerializer *ser = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer], [AFImageResponseSerializer serializer]]];
        _manager.responseSerializer = ser;
        
        AFJSONRequestSerializer *requestSerialzer = [AFJSONRequestSerializer serializer];
        requestSerialzer.timeoutInterval = 10.0;
        _manager.requestSerializer = requestSerialzer;
        
        _netWorkConfig = [MNetworkConfig shareMNetworkConfig];
        
        self.memoryCache = [MMemoryCache new];
    }
    return self;
}


- (void)addRequest:(MNetworkBaseRequest *)request
{
    if (request.requestHeader) {//设置请求头
        for (NSString *key in request.requestHeader.allKeys) {
            [_manager.requestSerializer setValue:request.requestHeader[key] forHTTPHeaderField:key];
        }
    }
    NSString *url = [self buildRequestUrlWithRequest:request];
    
    switch (request.requestMethod) {//get
        case MRequestMethodGet: {
            if (request.requestType == MRequestTypeNormal) {
                request.sessionTask = [_manager GET:url parameters:[request.parameter copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    request.responseObject = responseObject;
                    DLog(@"%@", responseObject);
                    [self handleRequestResult:request];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    DLog(@"%@", error);
                    [self handleRequestResult:request];
                }];
                [self addOperation:request];
            }else if (request.requestType == MRequestTypeDownload){
                if ([request isKindOfClass:[MNetworkBackgroundDownloadRequest class]]) {  // 后台下载任务
                    MNetworkBackgroundDownloadRequest *request1 = (MNetworkBackgroundDownloadRequest *)request;
                    dispatch_async(self.queue, ^{
                        NSError *error = nil;
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:0 error:&error];
                        
                        [[NSFileManager defaultManager] createFileAtPath:request1.storagePath contents:data attributes:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([request1.delegate respondsToSelector:@selector(requestDidFinishSuccess:)]) {
                                [request1.delegate requestDidFinishSuccess:request1];
                            }
                        });
                    });
                }else if ([request isKindOfClass:[MNetworkDownloadRequest class]]){   // 正常下载任务
                    MNetworkDownloadRequest *request1 = (MNetworkDownloadRequest *)request;
                    __block id image = nil;
                    // NSCache 判断有没有
                    image = [self.memoryCache objectForKey:request1.detailurl];
                    if (image) {
                        if (request1.successBlock) {
                            request1.successBlock(image);
                        }
                        return;
                    }
                    // 判断文件有没有
                    if ([request1 isExist]) {
                        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
//                            image = [UIImage imageWithContentsOfFile:request1.storagePath];
                            NSData *imageDate = [NSData dataWithContentsOfFile:request1.storagePath];
                            image = [UIImage imageWithData:imageDate];
                            [self.memoryCache setObject:image forKey:request1.detailurl withCost:imageDate.length];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (request1.successBlock) {
                                    request1.successBlock(image);

                                    if ([request1.delegate respondsToSelector:@selector(requestDidFinishSuccess:)]) {
                                        [request1.delegate requestDidFinishSuccess:request];
                                    }
                                }
                            });
                        });
                        return;
                    }
                    
                    //  防止多次同时下载同一个东西
                    if (self.downloadRequestRecord[request1.detailurl]) {//正在下载
                        NSArray *array = self.downloadRequestRecord[request1.detailurl];
                        NSArray *array1 = [array arrayByAddingObject:request1];
                        self.downloadRequestRecord[request1.detailurl] = array1;
                        
                        break;
                    }else{
                        self.downloadRequestRecord[request1.detailurl] = @[request1];
                    }
                    
                    // 没有的话开始下载 、下载存到缓存、文件中
                    
                    request.sessionTask = [_manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                            //                        [self.downloadCache setObject:responseObject forKey:request1.detailurl];
                            switch (request1.type) {
                                case Image: {
                                    UIImage *downloadImage = responseObject;
                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                    NSString *contentType = httpResponse.allHeaderFields[@"Content-type"];
                                    NSData *imageData = nil;
                                    
                                    if ([contentType isEqualToString:@"image/png"]){
                                        imageData = UIImagePNGRepresentation(downloadImage);
                                    } else {
                                        imageData = UIImageJPEGRepresentation(downloadImage, 1.0);
                                    }
                                    [self.memoryCache setObject:image forKey:request1.detailurl withCost:imageData.length];
                                    [[NSFileManager defaultManager] createFileAtPath:request1.storagePath contents:imageData attributes:nil];
                                    
                                    break;
                                }
                                case Voice: {
                                    
                                    break;
                                }
                            }
                        });
                        
                        request1.responseObject = responseObject;
                        [self handleDownloadRequestResult:request1];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self handleDownloadRequestResult:request1];
                    }];
                    }

                }

            break;
        }
        case MRequestMethodPost: {//post
            
            request.sessionTask = [_manager POST:url parameters:[request.parameter copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                request.responseObject = responseObject;
                DLog(@"%s - %@", __func__,responseObject);
                [self handleRequestResult:request];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"%@", error);
                [self handleRequestResult:request];
            }];
            
            break;
        }
        case MRequestMethodDelete: {
            
            request.sessionTask = [_manager DELETE:url parameters:[request.parameter copy] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                request.responseObject = responseObject;
                DLog(@"%s - %@", __func__,responseObject);
                [self handleRequestResult:request];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"%@", error);
                [self handleRequestResult:request];
            }];
            
        }
            
    }

    [self addOperation:request];
}

#pragma mark -

- (void)handleDownloadRequestResult:(MNetworkDownloadRequest *)request
{
    NSInteger statusCode = request.responseStatusCode;
    if (statusCode >= 200 && statusCode <= 299) {//请求成功
        NSArray *array = self.downloadRequestRecord[request.detailurl];
        for (MNetworkDownloadRequest *request1 in array) {
            if (request1.successBlock) {
                request1.successBlock(request.responseObject);
            }
            if ([request1.delegate respondsToSelector:@selector(requestDidFinishSuccess:)]) {
                [request1.delegate requestDidFinishSuccess:request];
            }
        }

        [self.downloadRequestRecord removeObjectForKey:request.detailurl];

    }else {
        
        MNetworkErrorModel *model = [MNetworkErrorModel errorModelWithErrorCode:statusCode description:request.sessionTask.error];
        
        if (request.failureBlock) {
            request.failureBlock(model);
        }
        if ([request.delegate respondsToSelector:@selector(requestDidFinishFailure:withError:)]) {
            [request.delegate requestDidFinishFailure:request withError:model];
        }
        [self.downloadRequestRecord removeObjectForKey:request.detailurl];
    }
    request.responseObject = nil;

    [self removeOperation:request];

}

/**
 *  处理网络请求完成结果
 */
- (void)handleRequestResult:(MNetworkBaseRequest *)request
{
    NSInteger statusCode = request.responseStatusCode;
    if (statusCode >= 200 && statusCode <= 299) {//请求成功
        [MNetworkHelper analysisResponsedData:request.responseObject WithSuccessBlock:^(id data) {
            if (request.successBlock) {
                request.successBlock(data);
            }
            
            if ([request.delegate respondsToSelector:@selector(requestDidFinishSuccess:)]) {
                [request.delegate requestDidFinishSuccess:request];
            }
            
        } failureBlock:^(id errors, NSInteger statusCode) {
            
            MNetworkErrorModel *model = [MNetworkErrorModel errorModelWithErrorCode:statusCode description:errors];
            
            if (request.failureBlock) {
                request.failureBlock(model);
            }
            
            if ([request.delegate respondsToSelector:@selector(requestDidFinishFailure:withError:)]) {
                [request.delegate requestDidFinishFailure:request withError:model];
            }
            
        }];
    }else {
        MNetworkErrorModel *model = [MNetworkErrorModel errorModelWithErrorCode:statusCode description:request.sessionTask.error];
        if (request.failureBlock) {
            request.failureBlock(model);
        }
        if ([request.delegate respondsToSelector:@selector(requestDidFinishFailure:withError:)]) {
            [request.delegate requestDidFinishFailure:request withError:model];
        }
    }

    [self removeOperation:request];

}

/**
 *  拼接参数，获得请求的url
 */
- (NSString *)buildRequestUrlWithRequest:(MNetworkBaseRequest *)request
{
    switch (request.requestType) {
        case MRequestTypeNormal: {
            return [NSString stringWithFormat:@"%@/%@", _netWorkConfig.baseUrl, request.detailurl];
            break;
        }
        case MRequestTypeDownload: {
            if (request.detailurl) {
               return [NSString stringWithFormat:@"%@/%@", _netWorkConfig.CDNUrl, request.detailurl];
            } else {
                return request.url;
            }
            break;
        }
    }
}

- (void)addOperation:(MNetworkBaseRequest *)request
{
    NSString *key = [NSString stringWithFormat:@"%ld", request.hash];
    @synchronized(self) {
        self.requestRecord[key] = request;
    }
}

- (void)removeOperation:(MNetworkBaseRequest *)request
{
    NSString *key = [NSString stringWithFormat:@"%ld", request.hash];
    @synchronized(self) {
        [_requestRecord removeObjectForKey:key];
    }
}

#pragma mark - 懒加载

- (NSCache *)downloadCache
{
    if (_downloadCache == nil) {
        _downloadCache = [[NSCache alloc]init];
        _downloadCache.countLimit = 60 * 1024 * 1024;
    }
    return _downloadCache;
}

- (NSMutableDictionary *)requestRecord
{
    if (_requestRecord == nil) {
        _requestRecord = [NSMutableDictionary dictionary];
    }
    return _requestRecord;
}

- (NSMutableDictionary *)downloadRequestRecord
{
    if (_downloadRequestRecord == nil) {
        _downloadRequestRecord = [NSMutableDictionary dictionary];
    }
    return _downloadRequestRecord;
}


- (dispatch_queue_t)queue
{
    if (!_queue) {
        _queue = dispatch_queue_create("blue", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}
















@end

@interface MNetworkGroupAgent ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation MNetworkGroupAgent

static id mNetworkGroupAgent = nil;

+ (instancetype)shareMNetworkGroupAgent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mNetworkGroupAgent = [[self alloc]init];
    });
    return mNetworkGroupAgent;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mNetworkGroupAgent = [super allocWithZone:zone];
    });
    return mNetworkGroupAgent;
}

- (void)addGroupRequest:(id)request
{
    [self.set addObject:request];
}

- (void)removeGroupRequest:(id)request
{
    ((MNetworkGroupRequest *)request).success = nil;
    ((MNetworkGroupRequest *)request).failure = nil;
    
    [self.set removeObject:request];
    request = nil;
}

- (NSMutableSet *)set
{
    if (_set == nil) {
        _set = [[NSMutableSet alloc]init];
    }
    return _set;
}

@end


@interface MNetworkChainAgent ()

@property (nonatomic, strong) NSMutableSet *chainRequestSet;

@end

@implementation MNetworkChainAgent

static MNetworkChainAgent *mNetworkChainAgent = nil;

+ (instancetype)shareMNetworkChainAgent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mNetworkChainAgent = [[self alloc] init];
        mNetworkChainAgent.chainRequestSet = [NSMutableSet set];
    });
    return mNetworkChainAgent;
}


- (void)addChainRequest:(MNetworkChainRequest *)request
{
    [_chainRequestSet addObject:request];
}

- (void)removeChainRequest:(MNetworkChainRequest *)request
{
    request.successBlock = nil;
    request.failureBlock = nil;
    
    [_chainRequestSet removeObject:request];
    request = nil;
}




@end


