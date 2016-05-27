//
//  MNetworkDownloadRequest.h
//  MNetWork
//
//  Created by developer on 16/2/17.
//  Copyright © 2016年 developer. All rights reserved.
//

#import "MNetworkBaseRequest.h"
typedef NS_ENUM(NSInteger, FileType) {
    Image,
    Voice
};



@interface MNetworkDownloadRequest : MNetworkBaseRequest

/*  存储路径 **/
@property (nonatomic, copy, readonly) NSString *storagePath;
/*  文件的类型 **/
@property (nonatomic, assign) FileType type;
/*  是否已经下载 **/
@property (nonatomic, assign, getter=isExist, readonly) BOOL exist;


/**
 *  工厂方法 初始化一个下载请求
 *
 */
+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl fileType:(FileType)type;

/**
 *  工厂方法 初始化一个下载请求, 该URL即为实际请求URL,不加CDN
 *
 */
+ (instancetype)downloadRequestWithUrl:(NSString *)url fileType:(FileType)type;


@end
