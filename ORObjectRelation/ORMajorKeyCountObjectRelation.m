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

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated{
    return [super relationWithName:name defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated{
    return [super initWithName:name defaultCount:defaultCount];
}

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;{
    return [[self alloc] initWithObjectID:objectID domain:domain defaultCount:defaultCount];
}

- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;{
    if (self = [super initWithName:[domain stringByAppendingString:objectID] defaultCount:defaultCount]) {
        self.objectID = objectID;
    }
    return self;
}

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    return [domain stringByAppendingString:objectID];
}

@end

@implementation ORObjectRelation (ChatMessage)

- (void)removeSubRelationWithObjectID:(NSString *)objectID{
    ORObjectRelation *relation = [[[self subRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"objectID == %@", objectID]] firstObject];
    
    [self removeSubRelation:relation];
}

- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;{
    [self removeSubRelationNamed:[ORMajorKeyCountObjectRelation nameWithObjectID:objectID domain:domain]];
}

@end
