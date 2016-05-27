//
//  UIImage+MNetwork.h
//  Memory
//
//  Created by zyx on 16/4/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MNetwork)


/**
 *  根据图片的url下载图片
 *
 *  @param detailUrl <#detailUrl description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)downloadImageWithDetailUrl:(NSString *)detailUrl
                      successBlock:(void(^)(UIImage *image))success
                      failureBlock:(void(^)(void))failure;



@end
