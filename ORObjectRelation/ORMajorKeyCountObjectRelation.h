//
//  ORMajorKeyCountObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/13.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORCountObjectRelation.h"

@interface ORMajorKeyCountObjectRelation : ORCountObjectRelation

@property (nonatomic, copy, readonly) NSString *objectID;

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;
- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end

@interface ORMajorKeyCountObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSUInteger)defaultCount;
- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSUInteger)defaultCount;

@end

@interface ORMajorKeyCountObjectRelation (NSRemoveSubRelation)

- (void)removeSubRelationWithObjectID:(NSString *)objectID;
- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end

@interface ORMajorKeyCountObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount ORObjectRelationDeprecated(relationWithObjectID:domain:defaultCount);
- (instancetype)initWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount ORObjectRelationDeprecated(initWithObjectID:domain:defaultCount:);

@end
