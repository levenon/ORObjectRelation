//
//  ORCountObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/11.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORObjectRelation.h"

@interface ORCountObjectRelation : ORObjectRelation

@property (nonatomic, assign) NSUInteger count;

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;
- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;

- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error;

@end

@interface ORCountObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount;
- (instancetype)initWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount;
- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error;

@end

@interface ORCountObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(relationWithName:defaultCount:);
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(initWithName:defaultCount);
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error ORObjectRelationDeprecated(registerObserverNamed:countPicker:error);

@end

@interface ORCountObjectRelation (NSAbsoluteCount)

@property (nonatomic, assign, readonly) NSUInteger absoluteCount;

@end
