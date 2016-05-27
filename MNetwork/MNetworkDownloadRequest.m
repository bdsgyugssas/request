//
//  MNetworkDownloadRequest.m
//  MNetWork
//
//  Created by developer on 16/2/17.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkDownloadRequest.h"
#import <UIKit/UIKit.h>

@interface MNetworkDownloadRequest()

@property (nonatomic, copy) NSString *detailSrting;

@property (nonatomic, copy) NSString *basePath;

@end

@implementation MNetworkDownloadRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestType = MRequestTypeDownload;
    }
    return self;
}

+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl fileType:(FileType)type
{
    MNetworkDownloadRequest *request = [[MNetworkDownloadRequest alloc]initWithDetailUrl:detailUrl Method:MRequestMethodGet MrequestType:MRequestTypeDownload RequestHeader:nil Parameter:nil];
    request.type = type;
    return request;
}

+ (instancetype)downloadRequestWithUrl:(NSString *)url fileType:(FileType)type
{
    MNetworkDownloadRequest *request = [[MNetworkDownloadRequest alloc]initWithUrl:url];
    request.type = type;
    return request;
}

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.detailurl = nil;
        self.url = url;
        self.requestType = MRequestTypeDownload;
        self.requestMethod = MRequestMethodGet;
        self.parameter = nil;
    }
    return self;
}

- (NSString *)basePath
{
    if (_basePath == nil) {
        _basePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Mcache"];
        switch (_type) {
            case Image: {
                _basePath = [_basePath stringByAppendingPathComponent:@"image"];
                break;
            }
            case Voice: {
                _basePath = [_basePath stringByAppendingPathComponent:@"voice"];
                break;
            }
        }
    }
    return _basePath;
}

- (NSString *)storagePath
{
    switch (_type) {
        case Image: {
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.basePath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            return [_basePath stringByAppendingPathComponent:self.detailurl? self.detailurl:self.url];
            break;
        }
        case Voice: {
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.basePath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            return [_basePath stringByAppendingPathComponent:self.detailurl? self.detailurl:self.url];
            break;
        }
    }
}

- (BOOL)isExist
{   
   return [[NSFileManager defaultManager] fileExistsAtPath:self.storagePath];
}

//- (void)startWithCompleteBlockSuccess:(MRequestSuccessBlock)success failure:(MRequestFailureBlock)failure
//{
//    [super startWithCompleteBlockSuccess:success failure:failure animated:YES];
//}

@end
