//
//  ORCountObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/11.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORCountObjectRelation.h"

@interface ORCountObjectRelation ()

@property (nonatomic, strong) id value;

@end

@implementation ORCountObjectRelation
@dynamic value;

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;{
    return [super relationWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;{
    return [super initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error __deprecated{
    return [super registerObserverNamed:name picker:picker error:error];
}

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;{
    return [[self alloc] initWithName:name defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSInteger)defaultCount;{
    return [super initWithName:name defaultValue:@(defaultCount) valueTransformer:ORObjectRelationSummationValueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error;{
    return [super registerObserverNamed:name picker:^(id value) {
        if (countPicker) {
            countPicker([value integerValue]);
        }
    } error:error];
}

- (void)setCount:(NSUInteger)count{
    count = MAX(count, 0);
    if (count != [self count]) {
        self.value = @(count);
    }
}

- (NSUInteger)count {
    return [[self value] integerValue];
}

@end
