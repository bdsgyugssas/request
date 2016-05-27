//
//  MNetworkConfig.h
//  MNetWork
//
//  Created by developer on 16/2/16.
//  Copyright © 2016年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetworkConfig : NSObject
/*  基础接口 **/
@property (nonatomic, copy) NSString *baseUrl;
/*  单例 **/
+ (instancetype)shareMNetworkConfig;
/*  CDN接口 **/
@property (nonatomic, copy) NSString *CDNUrl;



@end
