//
//  ORMajorKeyCountObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/13.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORMajorKeyCountObjectRelation.h"

@interface ORMajorKeyCountObjectRelation ()

@property (nonatomic, copy) NSString *objectID;

@end

@implementation ORMajorKeyCountObjectRelation

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;{
    return [[self alloc] initWithObjectID:objectID domain:domain queue:queue defaultCount:defaultCount];
}

- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;{
    if (self = [super initWithName:[domain stringByAppendingString:objectID] queue:queue defaultCount:defaultCount]) {
        self.objectID = objectID;
    }
    return self;
}

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    return [domain stringByAppendingString:objectID];
}

@end

@implementation ORMajorKeyCountObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSUInteger)defaultCount;{
    return [self relationWithObjectID:objectID domain:domain queue:nil defaultCount:defaultCount];
}

- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSUInteger)defaultCount;{
    return [self initWithObjectID:objectID domain:domain queue:nil defaultCount:defaultCount];
}

@end

@implementation ORMajorKeyCountObjectRelation (NSRemoveSubRelation)

- (void)removeSubRelationWithObjectID:(NSString *)objectID{
    ORObjectRelation *relation = [[[self subRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"objectID == %@", objectID]] firstObject];
    
    [self removeSubRelation:relation];
}

- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    [self removeSubRelationNamed:[ORMajorKeyCountObjectRelation nameWithObjectID:objectID domain:domain]];
}

@end

@implementation ORMajorKeyCountObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount __deprecated{
    return [super relationWithName:name defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount __deprecated{
    return [super initWithName:name defaultCount:defaultCount];
}

@end
