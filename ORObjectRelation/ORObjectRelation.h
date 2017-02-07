//
//  ORObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/10.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORObjectRelationSummationValueTransformer ^(NSArray *inputs, id base){ inputs = inputs ?: @[]; return [(base ? [inputs arrayByAddingObject:base]: inputs) valueForKeyPath:@"@sum.floatValue"]; }

#define ORObjectRelationMaxValueTransformer ^(NSArray *inputs, id base){ inputs = inputs ?: @[]; return [(base ? [inputs arrayByAddingObject:base]: inputs) valueForKeyPath:@"@max.floatValue"]; }

#define ORObjectRelationMinValueTransformer ^(NSArray *inputs, id base){ inputs = inputs ?: @[]; return [(base ? [inputs arrayByAddingObject:base]: inputs) valueForKeyPath:@"@min.floatValue"]; }

#define ORObjectRelationAverageValueTransformer ^(NSArray *inputs, id base){ inputs = inputs ?: @[]; return [)base ? [inputs arrayByAddingObject:base]: inputs) valueForKeyPath:@"@avg.floatValue"]; }

extern NSString * const ORObjectRelationErrorDomain;
extern NSString * const ORObjectRelationObserverDefaultName;

@interface ORObjectRelationObserver : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) void (^picker)(id value);

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id value))picker;

@end

@interface ORObjectRelation : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSArray<ORObjectRelation *> *subRelations;

@property (nonatomic, strong, readonly) NSArray<ORObjectRelationObserver *> *observers;

@property (nonatomic, strong, readonly) id value;

@property (nonatomic, strong, readonly) id base;

@property (nonatomic, strong, readonly) id object;

@property (nonatomic, assign, readonly) ORObjectRelation *parentObjectRelation;

@property (nonatomic, copy, readonly) id (^valueTransformer)(NSArray *inputs, id base);

- (id)subRelationNamed:(NSString *)name;
- (id)observerNamed:(NSString *)name;

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer;
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer;

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error;
- (void)removeObserverNamed:(NSString *)name;

- (BOOL)addSubRelation:(ORObjectRelation *)subRelation error:(NSError **)error;
- (void)removeSubRelation:(ORObjectRelation *)subRelation;
- (void)removeSubRelationNamed:(NSString *)subRelationName;
- (void)removeAllSubRelations;

- (void)clean;
- (void)removeFromParentObjectRelation;

@end
