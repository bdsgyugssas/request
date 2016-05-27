//
//  MMemoryCache.h
//  Mcache
//
//  Created by zyx on 16/5/27.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMemoryCache : NSObject


- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost;

- (id)objectForKey:(id)key;



@end
