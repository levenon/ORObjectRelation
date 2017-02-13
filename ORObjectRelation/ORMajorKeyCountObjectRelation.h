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

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated;
- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount __deprecated;

+ (instancetype)relationWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;
- (instancetype)initWithObjectID:(NSString *)objectID domain:(NSString *)domain defaultCount:(NSInteger)defaultCount;

+ (NSString *)nameWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end

@interface ORObjectRelation (ChatMessage)

- (void)removeSubRelationWithObjectID:(NSString *)objectID;

- (void)removeSubRelationWithObjectID:(NSString *)objectID domain:(NSString *)domain;

@end
