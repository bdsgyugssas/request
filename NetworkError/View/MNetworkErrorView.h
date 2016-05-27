//
//  MNetworkErrorView.h
//  Memory
//
//  Created by zyx on 16/5/10.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)(void);

@interface MNetworkErrorView : UIView

+ (void)showNetworkErrorInView:(UIView *)view containTabberHeight:(BOOL)flag tapped:(TapBlock)block ;

@end
