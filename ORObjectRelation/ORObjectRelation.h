//
//  ORObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/10.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORObjectRelationSummationValueTransformer ^(NSArray *subValues){ subValues = subValues ?: @[]; return [subValues valueForKeyPath:@"@sum.floatValue"]; }
#define ORObjectRelationMaxValueTransformer ^(NSArray *subValues){ subValues = subValues ?: @[]; return [subValues valueForKeyPath:@"@max.floatValue"]; }
#define ORObjectRelationMinValueTransformer ^(NSArray *subValues){ subValues = subValues ?: @[]; return [subValues valueForKeyPath:@"@min.floatValue"]; }
#define ORObjectRelationAverageValueTransformer ^(NSArray *subValues){ subValues = subValues ?: @[]; return [subValues valueForKeyPath:@"@avg.floatValue"]; }


#define ORObjectRelationDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

extern NSString * const ORObjectRelationErrorDomain;

@class ORObjectRelationObserver;

@interface ORObjectRelation : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, strong, readonly) dispatch_queue_t queue;

@property (nonatomic, copy, readonly) NSArray<ORObjectRelation *> *subRelations;

@property (nonatomic, copy, readonly) NSArray<ORObjectRelationObserver *> *observers;

@property (nonatomic, weak, readonly) ORObjectRelation *parentObjectRelation;

@property (nonatomic, copy, readonly) id (^valueTransformer)(NSArray *subValues);

@property (nonatomic, copy) void (^cleanCompletion)(id objectRelation);

@property (nonatomic, strong) id value;

@property (nonatomic, strong) id object;

// hronization will be forbidden if NO, default is YES.
@property (nonatomic, assign, getter=isEnable) BOOL enable;

@property (nonatomic, assign, getter=isAllow) BOOL allow;

- (id)subRelationNamed:(NSString *)name;
- (id)observerNamed:(NSString *)name;

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;
- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;

- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker error:(NSError **)error;
- (void)removeObserverNamed:(NSString *)name;

- (BOOL)addSubRelation:(ORObjectRelation *)subRelation error:(NSError **)error;
- (void)removeSubRelation:(ORObjectRelation *)subRelation;
- (void)removeSubRelations:(NSArray<ORObjectRelation *> *)subRelations;
- (void)removeSubRelationNamed:(NSString *)subRelationName;
- (void)removeAllSubRelations;

- (void)clean;
- (void)removeFromParentObjectRelation;
- (void)cleanAndRemoveFromParentObjectRelation;

@end

@interface ORObjectRelation (NSSharedQueue)

+ (dispatch_queue_t)sharedQueue;

+ (dispatch_queue_t)queueNamed:(NSString *)name;

@end

@interface ORObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(relationWithName:queue:defaultValue:valueTransformer:);
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer ORObjectRelationDeprecated(initWithName:queue:defaultValue:valueTransformer:);
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error ORObjectRelationDeprecated(registerObserverNamed:queue:picker:error:);

@end
