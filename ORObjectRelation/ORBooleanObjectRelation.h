//
//  ORBooleanObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/12.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORObjectRelation.h"

@interface ORBooleanObjectRelation : ORObjectRelation

@property (nonatomic, assign) BOOL boolean;

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultBoolean:(BOOL)defaultBoolean;
- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultBoolean:(BOOL)defaultBoolean;
- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;

@end

@interface ORBooleanObjectRelation (NSQueueDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;
- (instancetype)initWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;
- (BOOL)registerObserverNamed:(NSString *)name booleanPicker:(void (^)(id relation, BOOL boolean))booleanPicker error:(NSError **)error;

@end

@interface ORBooleanObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(relationWithName:defaultBoolean:);
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(initWithName:defaultBoolean:);
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error ORObjectRelationDeprecated(registerObserverNamed:booleanPicker:error:);

@end
