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

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;{
    return [super relationWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer __deprecated;{
    return [super initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error __deprecated{
    return [super registerObserverNamed:name picker:picker error:error];
}

+ (instancetype)relationWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;{
    return [[self alloc] initWithName:name defaultBoolean:(BOOL)defaultBoolean];
}

- (instancetype)initWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;{
    return [super initWithName:name defaultValue:@(defaultBoolean) valueTransformer:ORObjectRelationSummationValueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name booleanPicker:(void (^)(BOOL boolean))booleanPicker error:(NSError **)error;{
    return [super registerObserverNamed:name picker:^(id value) {
        if (booleanPicker) {
            booleanPicker([value boolValue]);
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
