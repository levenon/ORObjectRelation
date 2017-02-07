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

@interface ORObjectRelationObserverSetter : NSObject

@property (nonatomic, assign) id observer;

@property (nonatomic, strong) NSMutableArray<ORObjectRelation *> *observedObjectRelations;

@end

@implementation ORObjectRelationObserverSetter

- (NSMutableArray<ORObjectRelation *> *)observedObjectRelations{
    if (!_observedObjectRelations) {
        _observedObjectRelations = [NSMutableArray array];
    }
    return _observedObjectRelations;
}

- (void)dealloc{
    [self clear];
}

- (void)clear{
    for (ORObjectRelation *relation in [self observedObjectRelations]) {
        [relation removeObserverNamed:ORObjectRelationObserverName([self observer])];
    }
}

@end

@interface NSObject (ORObjectRelationObserverSetter)

@property (nonatomic, strong, readonly) ORObjectRelationObserverSetter *objectRelationObserverSetter;

@end

@implementation NSObject (ORObjectRelationObserverSetter)

- (ORObjectRelationObserverSetter *)objectRelationObserverSetter{
    ORObjectRelationObserverSetter *setter = objc_getAssociatedObject(self, @selector(objectRelationObserverSetter));
    if (!setter) {
        setter = [ORObjectRelationObserverSetter new];
        objc_setAssociatedObject(self, @selector(objectRelationObserverSetter), setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return setter;
}

@end

@implementation NSObject (ObjectRelationObserver)

- (BOOL)registerObserveRelation:(ORObjectRelation *)relation picker:(void (^)(id value))picker error:(NSError **)error;{
    NSString *observerName = ORObjectRelationObserverName(self);
    BOOL success = [relation registerObserverNamed:observerName picker:picker error:error];
    if (success) {
        self.objectRelationObserverSetter.observer = self;
        [[[self objectRelationObserverSetter] observedObjectRelations] addObject:relation];
    }
    return success;
}

- (void)clearAllRegisteredRelations;{
    [[self objectRelationObserverSetter] clear];
}

@end

@implementation NSObject (ORCountObjectRelation)

- (BOOL)registerObserveRelation:(ORCountObjectRelation *)relation countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error; {
    return [self registerObserveRelation:relation picker:^(id value) {
        countPicker([value integerValue]);
    } error:error];
}

@end

@implementation NSObject (ORBooleanObjectRelation)

- (BOOL)registerObserveRelation:(ORBooleanObjectRelation *)relation booleanPicker:(void (^)(BOOL boolean))booleanPicker error:(NSError **)error;{
    return [self registerObserveRelation:relation picker:^(id value) {
        booleanPicker([value boolValue]);
    } error:error];
}

@end

@implementation NSObject (ORSubRelationsObjectRelation)

- (BOOL)registerObserveRelation:(ORSubRelationsObjectRelation *)relation subRelationsPicker:(void (^)(NSArray *subRelations))subRelationsPicker error:(NSError **)error;{
    return [self registerObserveRelation:relation picker:^(NSArray *subRelations) {
        subRelationsPicker(subRelations);
    } error:error];
}

@end
