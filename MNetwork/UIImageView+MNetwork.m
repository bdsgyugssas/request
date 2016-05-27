//
//  UIImageView+Extension.m
//  Memory
//
//  Created by developer on 16/2/26.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "UIImageView+MNetwork.h"
#import "MNetworkDownloadRequest.h"
#import <objc/runtime.h>

@implementation UIImageView (MNetwork)

- (void)setImageWithUrl:(NSString *)url
{
    [self setImageWithUrl:url placeholder:nil];
}

- (void)setImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholderImage
{
    
    if (url == nil) {
        return;
    }
    if (placeholderImage) {
        self.image = placeholderImage;
    } 

    [self setLatestRequestWithUrl:url];
    MNetworkDownloadRequest *request = [[MNetworkDownloadRequest alloc]init];
    request.detailurl = url;
    [request startWithCompleteBlockSuccess:^(UIImage *responseData) {
        if ([[self requestUrl] isEqualToString:url]) {
            self.image = responseData;
            [self setNeedsLayout];
        }

    } failure:^(MNetworkErrorModel *model) {
        
    } immediately:YES];
    
}

static char loadUrlKey;

- (void)setLatestRequestWithUrl:(NSString *)url
{
    objc_setAssociatedObject(self, &loadUrlKey, url, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)requestUrl
{
    return objc_getAssociatedObject(self, &loadUrlKey);
}



 

@end
