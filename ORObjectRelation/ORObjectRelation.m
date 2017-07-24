//
//  ORObjectRelation.m
//  pyyx
//
//  Created by xulinfeng on 2017/1/10.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import "ORObjectRelation.h"
#import "ORObjectRelationObserver.h"

NSString * const ORObjectRelationErrorDomain = @"com.objectRelation.domain";
NSString * const ORObjectRelationQueueNamePrefix = @"com.objectRelation.queue.domain#";
NSString * const ORObjectRelationNamePrefix = @"com.objectRelation.name#";

@interface ORObjectRelation (){
    id _value;
    id _object;
    BOOL _enable;
    BOOL _allow;
}

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSMutableArray<ORObjectRelation *> *mutableSubRelations;

@property (nonatomic, strong) NSMutableArray<ORObjectRelationObserver *> *mutableObservers;

@property (nonatomic, copy) id (^valueTransformer)(NSArray *subValues);

@property (nonatomic, weak) ORObjectRelation *parentObjectRelation;

@property (nonatomic, strong) id innerValue;

@property (nonatomic, assign, readonly) BOOL innerAllow;

@end

@implementation ORObjectRelation

+ (instancetype)relationWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    return [[self alloc] initWithName:name queue:queue defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    if (self = [self initWithName:name queue:queue]) {
        _value = defaultValue;
        _valueTransformer = [valueTransformer copy];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name queue:(dispatch_queue_t)queue{
    if (self = [self init]) {
        _name = [name copy];
        _queue = queue ?: [[self class] sharedQueue];
        _enable = YES;
        _allow = YES;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@""];
}

- (void)dealloc{
    self.queue = nil;
    self.parentObjectRelation = nil;
    
    for (ORObjectRelation *relation in [[self mutableSubRelations] copy]) {
        relation.parentObjectRelation = nil;
    }
    
    [[self mutableSubRelations] removeAllObjects];
    [[self mutableObservers] removeAllObjects];
}

#pragma mark - accessor

- (id)subRelationNamed:(NSString *)name;{
    NSArray *subRelations = [[self mutableSubRelations] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    if (subRelations && [subRelations count]) return [subRelations firstObject];
    
    for (ORObjectRelation *subRelation in [self mutableSubRelations]) {
        ORObjectRelation *relation = [subRelation subRelationNamed:name];
        if (relation) return relation;
    }
    return nil;
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
    __block NSArray<ORObjectRelation *> *subRelations = nil;
    dispatch_sync([self queue], ^{
        subRelations = [[self mutableSubRelations] copy];
    });
    return subRelations;
}

- (NSArray<ORObjectRelationObserver *> *)observers{
    __block NSArray<ORObjectRelationObserver *> *observers = nil;
    dispatch_sync([self queue], ^{
        observers = [[self mutableObservers] copy];
    });
    return observers;
}

- (NSString *)name{
    __block id name = nil;
    dispatch_sync([self queue], ^{
        name = _name;
    });
    return name;
}

- (id)value{
    __block id value = nil;
    dispatch_sync([self queue], ^{
        value = _value;
    });
    return value;
}

- (void)setValue:(id)value{
    dispatch_async([self queue], ^{
        self.innerValue = value;
    });
}

- (id)innerValue {
    return _value;
}

- (void)setInnerValue:(id)innerValue{
    if (_enable) {
        _value = innerValue;
        
        [self _performObserver];
    }
}

- (id)object{
    __block id object = nil;
    dispatch_sync([self queue], ^{
        object = _object;
    });
    return object;
}

- (void)setObject:(id)object{
    dispatch_async([self queue], ^{
        _object = object;
    });
}

- (BOOL)isEnable{
    __block BOOL isEnable = NO;
    dispatch_sync([self queue], ^{
        isEnable = _enable;
    });
    return isEnable;
}

- (void)setEnable:(BOOL)enable{
    dispatch_async([self queue], ^{
        _enable = enable;
    });
}

- (BOOL)isAllow{
    __block BOOL isAllow = NO;
    dispatch_sync([self queue], ^{
        isAllow = _allow;
    });
    return isAllow;
}

- (void)setAllow:(BOOL)allow{
    dispatch_async([self queue], ^{
        _allow = allow;
        
        [self _performObserver];
    });
}

- (BOOL)innerAllow{
    return _allow;
}

#pragma mark - private

- (void)_appendObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker {
    ORObjectRelationObserver *observer = [[ORObjectRelationObserver alloc] initWithName:name queue:queue picker:picker];
    
    [self _appendObserver:observer];
}

- (void)_appendObserver:(ORObjectRelationObserver *)observer {
    dispatch_sync([self queue], ^{
        [[self mutableObservers] addObject:observer];
    });
}

- (void)_removeObserver:(ORObjectRelationObserver *)observer {
    dispatch_sync([self queue], ^{
        [[self mutableObservers] removeObject:observer];
    });
}

- (void)_appendSubRelation:(ORObjectRelation *)subRelation error:(NSError **)error; {
    subRelation.parentObjectRelation = self;
    __weak ORObjectRelation *weak_self = self;
    [subRelation registerObserverNamed:[ORObjectRelationNamePrefix stringByAppendingString:[subRelation name]] queue:[self queue] picker:^(id relation, id value) {
        __strong ORObjectRelation *self = weak_self;
        [self _updateValue];
    } error:nil];
    
    [self _appendSubRelation:subRelation];
    [self _updateValue];
    [self _performObserver];
}

- (void)_appendSubRelation:(ORObjectRelation *)subRelation{
    dispatch_sync([self queue], ^{
        [[self mutableSubRelations] addObject:subRelation];
    });
}

- (void)_removeSubRelation:(ORObjectRelation *)subRelation{
    subRelation.parentObjectRelation = nil;
    dispatch_sync([self queue], ^{
        [[self mutableSubRelations] removeObject:subRelation];
    });
    [self _updateValue];
    [self _performObserver];
}

- (void)_removeSubRelations:(NSArray<ORObjectRelation *> *)subRelations{
    for (ORObjectRelation *subRelation in subRelations) {
        subRelation.parentObjectRelation = nil;
    }
    dispatch_sync([self queue], ^{
        [[self mutableSubRelations] removeObjectsInArray:subRelations];
    });
    [self _updateValue];
    [self _performObserver];
}

- (void)_removeAllSubRelations{
    dispatch_sync([self queue], ^{
        [[self mutableSubRelations] removeAllObjects];
    });
    
    self.innerValue = nil;
}

- (void)_updateValue{
    
    NSMutableArray *subValues = [NSMutableArray new];
    for (ORObjectRelation *relation in [_mutableSubRelations copy]) {
        if (![relation innerAllow] || ![relation innerValue]) continue;
        
        [subValues addObject:[relation innerValue]];
    }
    
    self.innerValue = self.valueTransformer(subValues);
}

- (void)_performObserver{
    [self _performObserverWithValue:_value];
}

- (void)_performObserverWithValue:(id)value{
    dispatch_async([self queue], ^{
        for (ORObjectRelationObserver *observer in [self mutableObservers]) {
            dispatch_async([observer queue], ^{
                if ([observer picker]) {
                    observer.picker(self, value);
                }
            });
        }
    });
}

#pragma mark - public

- (BOOL)registerObserverNamed:(NSString *)name queue:(dispatch_queue_t)queue picker:(void (^)(id relation, id value))picker error:(NSError **)error;{
    ORObjectRelationObserver *existObserver = [self observerNamed:name];
    if (!existObserver) {
        [self _appendObserverNamed:name queue:queue picker:picker];
    } else if (error){
        *error = [NSError errorWithDomain:ORObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist observer named: %@.", name]}];
    }
    picker(self, _value);
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
    } else if (error){
        *error = [NSError errorWithDomain:ORObjectRelationErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Exist relation named: %@.", [subRelation name]]}];
    }
    return !exist;
}

- (void)removeSubRelation:(ORObjectRelation *)subRelation; {
    [self _removeSubRelation:subRelation];
}

- (void)removeSubRelations:(NSArray<ORObjectRelation *> *)subRelations;{
    [self _removeSubRelations:subRelations];
}

- (void)removeSubRelationNamed:(NSString *)subRelationName;{
    [self _removeSubRelation:[self subRelationNamed:subRelationName]];
}

- (void)removeAllSubRelations;{
    [self _removeAllSubRelations];
}

- (void)clean;{
    _object = nil;
    
    for (ORObjectRelation *relation in [self mutableSubRelations]) {
        [relation clean];
    }
    self.innerValue = nil;
    
    if ([self cleanCompletion]) {
        self.cleanCompletion(self);
    }
}

- (void)removeFromParentObjectRelation;{
    [[self parentObjectRelation] removeSubRelation:self];
}

- (void)cleanAndRemoveFromParentObjectRelation;{
    [self clean];
    [self removeFromParentObjectRelation];
}

@end

@implementation ORObjectRelation (NSSharedQueue)

+ (dispatch_queue_t)sharedQueue;{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [self queueNamed:@"global"];
    });
    return queue;
}

+ (dispatch_queue_t)queueNamed:(NSString *)name;{
    return dispatch_queue_create([[ORObjectRelationQueueNamePrefix stringByAppendingString:name] UTF8String], NULL);
}

@end

@implementation ORObjectRelation (NSDeprecated)

+ (instancetype)relationWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    return [self relationWithName:name queue:nil defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (instancetype)initWithName:(NSString *)name defaultValue:(id)defaultValue valueTransformer:(id (^)(NSArray *subValues))valueTransformer;{
    return [self initWithName:name queue:nil defaultValue:defaultValue valueTransformer:valueTransformer];
}

- (BOOL)registerObserverNamed:(NSString *)name picker:(void (^)(id relation, id value))picker error:(NSError **)error;{
    return [self registerObserverNamed:name queue:nil picker:picker error:error];
}

@end
