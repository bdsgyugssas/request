//
//  MNetworkErrorView.m
//  Memory
//
//  Created by zyx on 16/5/10.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MNetworkErrorView.h"
#import <Masonry.h>



@interface MNetworkErrorView ()

@property (nonatomic, copy) TapBlock tapBlock;

@property (nonatomic, assign) BOOL containTabbar;

@end

@implementation MNetworkErrorView

+ (void)showNetworkErrorInView:(UIView *)view containTabberHeight:(BOOL)flag tapped:(TapBlock)block
{
    
    DLog(@"%@", NSStringFromCGRect(view.frame));
    DLog(@"%f", HEIGHT);
    MNetworkErrorView *errorView = [[MNetworkErrorView alloc]init];
    errorView.backgroundColor = [UIColor colorWithIntegerRed:241 Integergreen:241 Integerblue:241];
    errorView.tapBlock = block;
    errorView.containTabbar = flag;
    [view addSubview:errorView];
    
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [errorView setupUI];
}


- (void)setupUI
{
    UIView *containView = [[UIView alloc]init];
    [self addSubview:containView];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        if (_containTabbar) {
            make.centerY.equalTo(self.mas_centerY).with.offset(- TabbarHeight / 2);
        } else {
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
        }
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(111);
    }];
    
 
    
//    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"network_error"];
    [containView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containView.mas_centerX).with.offset(0);
        make.top.equalTo(containView.mas_top).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
//
//    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"网络连接失败";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithIntegerRed:163 Integergreen:163 Integerblue:163];
    label.textAlignment = NSTextAlignmentCenter;
    [containView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(containView.mas_centerX).with.offset(0);
    }];
//
//    
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 3.0;
    button.layer.masksToBounds = YES;
    [button setTitle:@"重新连接" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setBackgroundColor:[UIColor colorWithIntegerRed:128 Integergreen:194 Integerblue:104]];
    [button addTarget:self action:@selector(operationBlock) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(14);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
}

- (void)operationBlock
{
    if (self.tapBlock) {
        self.tapBlock();
    }
    
    [self removeFromSuperview];
}


- (void)dealloc
{
    DLog(@"%s", __func__);
}

@end
