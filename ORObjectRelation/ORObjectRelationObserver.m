//
//  ORObjectRelationObserver.m
//  ORObjectRelationDemo
//
//  Created by Jave on 2017/7/24.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "ORObjectRelationObserver.h"

@interface ORObjectRelationObserver ()

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) void (^picker)(id relation, id value);

@end

@implementation ORObjectRelationObserver

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker;{
    if (self = [super init]) {
        self.name = name;
        self.picker = picker;
        self.queue = queue ?: dispatch_get_main_queue();
    }
    return self;
}

@end

@implementation ORObjectRelationObserver (NSDeprecated)

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id relation, id value))picker;{
    return [self initWithName:name queue:nil picker:picker];
}

@end
