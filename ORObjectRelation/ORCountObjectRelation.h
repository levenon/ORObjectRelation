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

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error __deprecated;

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;
- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;
- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error;

@end
