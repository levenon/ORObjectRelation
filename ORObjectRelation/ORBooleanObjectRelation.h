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

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer ORObjectRelationDeprecated(relationWithName:defaultBoolean:);
- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer ORObjectRelationDeprecated(initWithName:defaultBoolean:);
- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error ORObjectRelationDeprecated(registerObserverNamed:booleanPicker:error:);

+ (instancetype)relationWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;
- (instancetype)initWithName:(NSString *)name defaultBoolean:(BOOL)defaultBoolean;
- (BOOL)registerObserverNamed:(NSString *)name booleanPicker:(void (^)(BOOL boolean))booleanPicker error:(NSError **)error;

@end
