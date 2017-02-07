//
//  ORSubRelationsObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/22.
//  CopORight © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORSubRelationsObjectRelation.h"

@implementation NSArray (Mutable)

- (NSArray *)arrayByRemovingObject:(id)object{
    NSMutableArray *array = [self mutableCopy];
    [array removeObject:object];
    return array;
}

- (NSArray *)arrayByRemovingObjectAtIndex:(NSUInteger)index{
    NSMutableArray *array = [self mutableCopy];
    [array removeObjectAtIndex:index];
    return array;
}

- (NSArray *)arrayByAddingObject:(id)object{
    NSMutableArray *array = [self mutableCopy];
    [array addObject:object];
    return array;
}

- (NSArray *)arrayByInsertingObject:(id)object atIndex:(NSUInteger)index{
    NSMutableArray *array = [self mutableCopy];
    [array insertObject:object atIndex:index];
    return array;
}

@end

@interface ORSubRelationsObjectRelation ()

@property (nonatomic, copy) NSArray<ORObjectRelationObserver *> *subRelationsObservers;

@end

@implementation ORSubRelationsObjectRelation

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"subRelations" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    }
    return self;
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"subRelations"];
}

#pragma mark - protected

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == (__bridge void *)(self) && [keyPath isEqualToString:@"subRelations"]) {
        id value = change[NSKeyValueChangeNewKey];
        if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        }
        [self _performSubRelationsObserversWithValue:value];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - public

- (BOOL)registerSubRelationsObserverNamed:(NSString *)name picker:(void (^)(NSArray *subRelations))picker error:(NSError **)error;{
    ORObjectRelationObserver *existSubRelationsObserver = [self subRelationsObserverNamed:name];
    if (!existSubRelationsObserver) {
        [self _appendSubRelationsObserverNamed:name picker:picker];
    } else {
        *error = [NSError errorWithDomain:ORObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist observer named: %@.", name]}];
    }
    picker([self subRelations]);
    return existSubRelationsObserver == nil;
}

- (void)removeSubRelationsObserverNamed:(NSString *)name; {
    ORObjectRelationObserver *existSubRelationsObserver = [self subRelationsObserverNamed:name];
    if (existSubRelationsObserver) {
        [self _removeSubRelationsObserver:existSubRelationsObserver];
    }
}

#pragma mark - private

- (void)_appendSubRelationsObserverNamed:(NSString *)name picker:(void (^)(id value))picker {
    ORObjectRelationObserver *observer = [[ORObjectRelationObserver alloc] initWithName:name picker:picker];
    self.subRelationsObservers = [[self subRelationsObservers] arrayByAddingObject:observer];
}

- (void)_removeSubRelationsObserver:(ORObjectRelationObserver *)observer {
    self.subRelationsObservers = [[self subRelationsObservers] arrayByRemovingObject:observer];
}

- (void)_performSubRelationsObservers{
    [self _performSubRelationsObserversWithValue:[self subRelations]];
}

- (void)_performSubRelationsObserversWithValue:(id)value{
    for (ORObjectRelationObserver *observer in [self observers]) {
        if ([observer picker]) {
            observer.picker(value);
        }
    }
}

#pragma mark - accessor

- (id)subRelationsObserverNamed:(NSString *)name{
    return [[[self subRelationsObservers] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}

- (NSArray<ORObjectRelationObserver *> *)subRelationsObservers{
    if (!_subRelationsObservers) {
        _subRelationsObservers = @[];
    }
    return _subRelationsObservers;
}

@end
