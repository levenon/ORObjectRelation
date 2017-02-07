//
//  ORSubRelationsObjectRelation.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/22.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORCountObjectRelation.h"

@interface ORSubRelationsObjectRelation : ORCountObjectRelation

@property (nonatomic, copy, readonly) NSArray<ORObjectRelationObserver *> *subRelationsObservers;

- (BOOL)registerSubRelationsObserverNamed:(NSString *)name picker:(void (^)(NSArray *subRelations))picker error:(NSError **)error;

@end
