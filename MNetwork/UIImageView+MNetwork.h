//
//  UIImageView+Extension.h
//  Memory
//
//  Created by developer on 16/2/26.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MNetwork)

- (void)setImageWithUrl:(NSString *)url;

- (void)setImageWithUrl:(NSString *)url placeholder:(UIImage *)image;

@end
