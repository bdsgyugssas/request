//
//  UIImage+MNetwork.m
//  Memory
//
//  Created by zyx on 16/4/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "UIImage+MNetwork.h"
#import "MNetworkDownloadRequest.h"

@implementation UIImage (MNetwork)


+ (void)downloadImageWithDetailUrl:(NSString *)detailUrl successBlock:(void (^)(UIImage *))success failureBlock:(void (^)(void))failure
{
    MNetworkDownloadRequest *request = [[MNetworkDownloadRequest alloc]init];
    request.detailurl = detailUrl;
    [request startWithCompleteBlockSuccess:^(UIImage *responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(MNetworkErrorModel *model) {
        
    } immediately:YES];
    
}



@end
