//
//  ORBooleanObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/12.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORBooleanObjectRelation.h"

@interface ORBooleanObjectRelation ()

@property (nonatomic, strong) id value;

@end

@implementation ORBooleanObjectRelation
@dynamic value;

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultBoolean:(BOOL)defaultBoolean;{
    return [[self alloc] initWithName:name queue:queue defaultBoolean:defaultBoolean];
}

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultBoolean:(BOOL)defaultBoolean;{
    return [super initWithName:name queue:queue defaultValue:@(defaultBoolean) valueTransformer:ORObjectRelationSummationValueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;{
    return [super registerObserverNamed:name queue:queue picker:^(id relation, id value) {
        if (booleanPicker) {
            booleanPicker(relation, [value boolValue]);
        }
    } error:error];
}

- (void)setBoolean:(BOOL)boolean{
    self.value = @(boolean);
}

- (BOOL)boolean {
    return [[self value] boolValue];
}

@end

@implementation ORBooleanObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;{
    return [self relationWithName:name queue:nil defaultBoolean:defaultBoolean];
}

- (instancetype)initWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;{
    return [self initWithName:name queue:nil defaultBoolean:defaultBoolean];
}

- (BOOL)registerObserverNamed:(NSString *)name booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;{
    return [self registerObserverNamed:name queue:nil booleanPicker:booleanPicker error:error];
}

@end

@implementation ORBooleanObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    return [super relationWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    return [super initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error{
    return [super registerObserverNamed:name picker:picker error:error];
}

@end
