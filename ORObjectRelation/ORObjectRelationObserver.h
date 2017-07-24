//
//  ORObjectRelationObserver.h
//  ORObjectRelationDemo
//
//  Created by Jave on 2017/7/24.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ORObjectRelationObserverDefaultName;

@interface ORObjectRelationObserver : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t queue;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) void (^picker)(id relation, id value);

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker;

@end

@interface ORObjectRelationObserver (NSDeprecated)

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id relation, id value))picker;

@end
