//
//  MMemoryCache.m
//  Mcache
//
//  Created by zyx on 16/5/27.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "MMemoryCache.h"
#import <pthread.h>

@interface MLinkedMapNode : NSObject

@property (nonatomic, strong) MLinkedMapNode *prev;
@property (nonatomic, strong) MLinkedMapNode *next;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id key;

@property (nonatomic, assign) NSUInteger cost;

@end

@implementation MLinkedMapNode
@end


@interface MLinkedMap : NSObject

@property (nonatomic, strong) NSMutableDictionary *mapDict;

@property (nonatomic, strong) MLinkedMapNode *head;

@property (nonatomic, strong) MLinkedMapNode *tail;

@property (nonatomic, assign) NSUInteger currentCapacity;

@end


@implementation MLinkedMap

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapDict = [NSMutableDictionary new];
    }
    return self;
}

- (void)insertNodeAtHead:(MLinkedMapNode *)node
{
    if (_head) {
        node.next = _head;
        _head.prev = node;
        _head = node;
    } else {
        _head = node;
        _tail = node;

    }

}

- (void)bringNodeToHead:(MLinkedMapNode *)node
{
    if (node == _head) {
        return;
    }
    
    if (node == _tail) {
        _tail = node.prev;
        _tail.next = nil;
    } else {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    node.next = _head;
    node.prev = nil;
    _head.prev = node;
    _head = node;
}

- (void)removeTailNode
{
    if (_tail == nil) {
        return;
    }
    
    _currentCapacity -= _tail.cost;
    [_mapDict removeObjectForKey:_tail.key];
    
    if (_head == _tail) {
        _tail = _head = nil;
    } else {
        _tail.prev.next = nil;
        _tail = _tail.prev;
    }
    
    
}



@end





@interface MMemoryCache()

@property (nonatomic, strong) MLinkedMap *linkMap;

@property (nonatomic, assign) NSUInteger limitCapacity;

@property (nonatomic, assign) pthread_mutex_t lock;

@end

@implementation MMemoryCache


#pragma mark - 

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.linkMap = [MLinkedMap new];
        self.limitCapacity = 1024 * 1024 * 50;
        pthread_mutex_init(&_lock, NULL);
        
    }
    return self;
}

- (void)dealloc
{
    
    
}

#pragma mark - public

- (void)setObject:(id)object forKey:(id)key withCost:(NSUInteger)cost
{
    DLog(@"该卡片的内存大小：%ld", cost);
    if (!key) {
        return;
    }
    if (!object) { // 查看有无key对应的东西
    }
    pthread_mutex_trylock(&_lock);
    MLinkedMapNode *node = _linkMap.mapDict[key];
    if (node) { //  链表里面有key
        _linkMap.currentCapacity -= node.cost;
        node.value = object;
        node.cost = cost;
        _linkMap.currentCapacity += node.cost;
        
        [_linkMap bringNodeToHead:node];
    } else { // 链表里面没有key
        node = [MLinkedMapNode new];
        node.cost = cost;
        node.key = key;
        node.value = object;
        [_linkMap insertNodeAtHead:node];
        _linkMap.currentCapacity += node.cost;
        _linkMap.mapDict[node.key] = node;
    }
    NSLog(@"---------- 内存大小:%ld", _linkMap.currentCapacity);
    while (_linkMap.currentCapacity > _limitCapacity) {
        [_linkMap removeTailNode];
    }
    
    pthread_mutex_unlock(&_lock);
    
}


- (id)objectForKey:(id)key
{
    if (!key) {
        return nil;
    }
    MLinkedMapNode *node = _linkMap.mapDict[key];

    if (node) {
        [_linkMap bringNodeToHead:node];
        return node.value;
    }
    return nil;
}








@end
