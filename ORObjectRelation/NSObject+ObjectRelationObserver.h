//
//  NSObject+ObjectRelationObserver.h
//  ORObjectRelationDemo
//
//  Created by xulinfeng on 2017/1/17.
//  Copyright © 2017年 xulinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCountObjectRelation.h"
#import "ORBooleanObjectRelation.h"
#import "ORMajorKeyCountObjectRelation.h"

@interface NSObject (ObjectRelationObserver)

- (BOOL)registerObserveRelation:(ORObjectRelation *)relation picker:(void (^)(id value))picker error:(NSError **)error;
- (BOOL)registerObserveRelation:(ORCountObjectRelation *)relation countPicker:(void (^)(NSUInteger count))countPicker error:(NSError **)error;
- (BOOL)registerObserveRelation:(ORBooleanObjectRelation *)relation booleanPicker:(void (^)(BOOL boolean))booleanPicker error:(NSError **)error;

- (void)clearAllRegisteredRelations;

@end
