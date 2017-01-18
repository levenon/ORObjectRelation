//
//  ORObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/10.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORObjectRelation.h"

NSString * const ORObjectRelationErrorDomain = @"com.objectRelation.domain";
NSString * const ORObjectRelationObserverDefaultName = @"com.objectRelation.handle.default";

@interface ORObjectRelationObserver ()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) void (^picker)(id value);

@property (nonatomic, copy) void (^subRelationsChangedHandler)();

@end

@implementation ORObjectRelationObserver

- (instancetype)initWithName:(NSString *)name picker:(void (^)(id value))picker;{
    if (self = [super init]) {
        self.name = name;
        self.picker = picker;
    }
    return self;
}

@end

@interface ORObjectRelation (){
    id _value;
}

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray<ORObjectRelation *> *mutableSubRelations;

@property (nonatomic, strong) NSMutableArray<ORObjectRelationObserver *> *mutableObservers;

@property (nonatomic, strong) id value;

@property (nonatomic, strong) id base;

@property (nonatomic, strong) id detail;

@property (nonatomic, copy) id (^valueTransformer)(NSArray *inputs, id base);

@property (nonatomic, assign) ORObjectRelation *parentObjectRelation;

@end

@implementation ORObjectRelation

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer;{
    return [[self alloc] initWithName:name defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *inputs, id base))valueTransformer;{
    if (self = [self init]) {
        self.name = name;
        self.base = defaultValue;
        self.value = defaultValue;
        self.valueTransformer = valueTransformer;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(self)];
    }
    return self;
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id value))picker error:(NSError **)error; {
    ORObjectRelationObserver *existObserver = [self observerNamed:name];
    if (!existObserver) {
        [self _appendObserverNamed:name picker:picker];
    } else {
        *error = [NSError errorWithDomain:ORObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist observer named: %@.", name]}];
    }
    picker([self value]);
    return existObserver == nil;
}

- (void)removeObserverNamed:(NSString *)name; {
    ORObjectRelationObserver *existObserver = [self observerNamed:name];
    if (existObserver) {
        [self _removeObserver:existObserver];
    }
}

- (BOOL)addSubRelation:(ORObjectRelation *)subRelation error:(NSError **)error; {
    BOOL exist = [[self mutableSubRelations] containsObject:subRelation];
    if (!exist) {
        [self _appendSubRelation:subRelation error:error];
    } else {
        *error = [NSError errorWithDomain:ORObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist relation named: %@.", [subRelation name]]}];
    }
    return !exist;
}

- (void)removeSubRelation:(ORObjectRelation *)subRelation; {
    [self _removeSubRelation:subRelation];
}

- (void)removeSubRelationNamed:(NSString *)subRelationName;{
    [self _removeSubRelation:[self subRelationNamed:subRelationName]];
}

- (void)removeAllSubRelations;{
    [self _removeAllSubRelations];
}

- (void)clean;{
    for (ORObjectRelation *relation in [self mutableSubRelations]) {
        [relation clean];
    }
    self.value = nil;
}

- (void)removeFromParentObjectRelation;{
    
    [[self parentObjectRelation] removeSubRelation:self];
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"value"];
}

#pragma mark - protected

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context != (__bridge void *)(self)) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    } else if ([keyPath isEqualToString:@"value"]){
        id value = change[NSKeyValueChangeNewKey];
        if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        }
        [self _performObserverWithValue:value];
    }
}

#pragma mark - private

- (void)_appendObserverNamed:(NSString *)name picker:(void (^)(id value))picker {
    ORObjectRelationObserver *observer = [[ORObjectRelationObserver alloc] initWithName:name picker:picker];
    
    [[self mutableObservers] addObject:observer];
}

- (void)_removeObserver:(ORObjectRelationObserver *)observer {
    [[self mutableObservers] removeObject:observer];
}

- (void)_appendSubRelation:(ORObjectRelation *)subRelation error:(NSError **)error; {
    subRelation.parentObjectRelation = self;
    __block __weak typeof(self) weak_self = self;
    [subRelation registerObserverNamed:ORObjectRelationObserverDefaultName picker:^(id value) {
        if ([weak_self valueTransformer]) {
            value = weak_self.valueTransformer([[self mutableSubRelations] valueForKeyPath:@"@unionOfObjects.value"], [self base]);
        }
        weak_self.value = value;
    } error:error];
    
    [[self mutableSubRelations] addObject:subRelation];
    [self _performObserver];
}

- (void)_removeSubRelation:(ORObjectRelation *)subRelation{
    [[self mutableSubRelations] removeObject:subRelation];
    [self _performObserver];
}

- (void)_removeAllSubRelations{
    [[self mutableSubRelations] removeAllObjects];
    [self _performObserver];
}

- (void)_performObserver{
    
    [self _performObserverWithValue:[self value]];
}

- (void)_performObserverWithValue:(id)value{
    for (ORObjectRelationObserver *observer in [self mutableObservers]) {
        if ([observer picker]) {
            observer.picker(value);
        }
    }
}

#pragma mark - accessor

- (id)subRelationNamed:(NSString *)name;{
    return [[[self mutableSubRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}

- (id)observerNamed:(NSString *)name{
    return [[[self mutableObservers] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]] firstObject];
}

- (NSMutableArray<ORObjectRelation *> *)mutableSubRelations{
    if (!_mutableSubRelations) {
        _mutableSubRelations = [NSMutableArray array];
    }
    return _mutableSubRelations;
}

- (NSMutableArray<ORObjectRelationObserver *> *)mutableObservers{
    if (!_mutableObservers) {
        _mutableObservers = [NSMutableArray array];
    }
    return _mutableObservers;
}

- (NSArray<ORObjectRelation *> *)subRelations{
    return [[self mutableSubRelations] copy];
}

- (NSArray<ORObjectRelationObserver *> *)observsers{
    return [[self mutableObservers] copy];
}

- (void)setValue:(id)value{
    if (![_value isEqual:value]) {
        _value = value;
    }
}

@end
