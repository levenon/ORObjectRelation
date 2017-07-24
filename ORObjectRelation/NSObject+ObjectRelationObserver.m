//
//  NSObject+ObjectRelationObserver.m
//  ORObjectRelationDemo
//
//  Created by xulinfeng on 2017/1/17.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import "NSObject+ObjectRelationObserver.h"
#import <objc/runtime.h>

NSString * ORObjectRelationObserverName(id observer){
    return [NSString stringWithFormat:@"%@%d", NSStringFromClass([observer class]), (int)observer];
}

@interface ORObjectRelationProxy : NSObject

@property (nonatomic, assign) ORObjectRelation *relation;

@end

@implementation ORObjectRelationProxy

+ (instancetype)proxyWithRelation:(ORObjectRelation *)relation{
    return [[self alloc] initWithRelation:relation];
}

- (instancetype)initWithRelation:(ORObjectRelation *)relation{
    if (self = [super init]) {
        self.relation = relation;
    }
    return self;
}

@end

@interface ORObjectRelationObserverSetter : NSObject

@property (nonatomic, copy) NSString *observerName;

@property (nonatomic, strong) NSMutableArray<ORObjectRelationProxy *> *observedObjectRelationProxys;

@end

@implementation ORObjectRelationObserverSetter

- (NSMutableArray<ORObjectRelationProxy *> *)observedObjectRelationProxys{
    if (!_observedObjectRelationProxys) {
        _observedObjectRelationProxys = [NSMutableArray new];
    }
    return _observedObjectRelationProxys;
}

- (void)dealloc{
    [self clear];
}

- (void)clear{
    for (ORObjectRelationProxy *proxy in [self observedObjectRelationProxys]) {
        [[proxy relation] removeObserverNamed:[self observerName]];
    }
}

@end

@interface NSObject (ORObjectRelationObserverSetter)

@property (nonatomic, strong, readonly) ORObjectRelationObserverSetter *objectRelationSetter;

@end

@implementation NSObject (ORObjectRelationObserverSetter)

- (ORObjectRelationObserverSetter *)objectRelationSetter{
    ORObjectRelationObserverSetter *setter = objc_getAssociatedObject(self, @selector(objectRelationSetter));
    if (!setter) {
        setter = [ORObjectRelationObserverSetter new];
        objc_setAssociatedObject(self, @selector(objectRelationSetter), setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return setter;
}

@end

@implementation NSObject (ORObjectRelationObserver)

- (BOOL)observeRelation:(ORObjectRelation *)relation queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker error:(NSError **)error;{
    NSString *observerName = ORObjectRelationObserverName(self);
    BOOL success = [relation registerObserverNamed:observerName queue:queue picker:picker error:error];
    if (success) {
        self.objectRelationSetter.observerName = ORObjectRelationObserverName(self);
        [[[self objectRelationSetter] observedObjectRelationProxys] addObject:[ORObjectRelationProxy proxyWithRelation:relation]];
    }
    return success;
}

- (void)clearObservedRelations;{
    [[self objectRelationSetter] clear];
}

@end

@implementation NSObject (ORCountObjectRelation)

- (BOOL)observeRelation:(ORCountObjectRelation *)relation queue:(dispatch_queue_t)queue countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error; {
    return [self observeRelation:relation queue:queue picker:^(id relation, id value) {
        countPicker(relation, [value integerValue]);
    } error:error];
}

@end

@implementation NSObject (ORBooleanObjectRelation)

- (BOOL)observeRelation:(ORBooleanObjectRelation *)relation queue:(dispatch_queue_t)queue booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;{
    return [self observeRelation:relation queue:queue picker:^(id relation, id value) {
        booleanPicker(relation, [value boolValue]);
    } error:error];
}

@end

@implementation NSObject (ORObjectRelationObserver_NSDeprecated)

- (BOOL)registerObserveRelation:(ORObjectRelation *)relation picker:(void (^)(id relation, id value))picker error:(NSError **)error;{
    return [self observeRelation:relation queue:nil picker:picker error:error];
}

- (BOOL)registerObserveRelation:(ORCountObjectRelation *)relation countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error;{
    return [self observeRelation:relation queue:nil countPicker:countPicker error:error];
}

- (BOOL)registerObserveRelation:(ORBooleanObjectRelation *)relation booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;{
    return [self observeRelation:relation queue:nil booleanPicker:booleanPicker error:error];
}

- (void)clearAllRegisteredRelations;{
    return [self clearObservedRelations];
}

@end
