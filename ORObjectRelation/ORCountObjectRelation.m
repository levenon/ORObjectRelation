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

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;{
    return [[self alloc] initWithName:name queue:queue defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultCount:(NSUInteger)defaultCount;{
    return [super initWithName:name queue:queue defaultValue:@(defaultCount) valueTransformer:ORObjectRelationSummationValueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error;{
    return [super registerObserverNamed:name queue:queue picker:^(id relation, id value) {
        if (countPicker) {
            countPicker(relation, [value integerValue]);
        }
    } error:error];
}

- (void)setCount:(NSUInteger)count{
    [self setValue:@(count)];
}

- (NSUInteger)count {
    return [[self value] integerValue];
}

@end

@implementation ORCountObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount;{
    return [self relationWithName:name queue:nil defaultCount:defaultCount];
}

- (instancetype)initWithName:(NSString *)name defaultCount:(NSUInteger)defaultCount;{
    return [self initWithName:name queue:nil defaultCount:defaultCount];
}

- (BOOL)registerObserverNamed:(NSString *)name countPicker:(void (^)(id relation, NSUInteger count))countPicker error:(NSError **)error;{
    return [self registerObserverNamed:name queue:nil countPicker:countPicker error:error];
}

@end

@implementation ORCountObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer __deprecated;{
    return [super relationWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer __deprecated;{
    return [super initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error __deprecated{
    return [super registerObserverNamed:name picker:picker error:error];
}

@end

@implementation ORCountObjectRelation (NSAbsoluteCount)

- (NSUInteger)absoluteCount{
    __block id value = nil;
    dispatch_sync([self queue], ^{
        NSMutableArray *absoluteValues = [NSMutableArray new];
        
        for (ORCountObjectRelation *relation in [[self subRelations] copy]) {
            if (![relation isKindOfClass:[ORCountObjectRelation class]]) continue;
            if ([[relation subRelations] count]) {
                [absoluteValues addObject:@([relation absoluteCount])];
            } else {
                [absoluteValues addObject:@([relation count])];
            }
        }
        value = self.valueTransformer(absoluteValues);
    });
    
    return [value unsignedIntegerValue];
}

@end
