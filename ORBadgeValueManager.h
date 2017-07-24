//
//  ORBadgeValueManager.h
//  pyyx
//
//  Created by xulinfeng on 2017/1/11.
//  Copyright © 2017年 Chunlin Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ORObjectRelation/ORObjectRelationUmbrella.h>

extern NSString * const ORObjectRelationRootName;
extern NSString * const ORObjectRelationNormalMessageDomainName;

@interface ORBadgeValueManager : NSObject

/**
 *  name: com.pyyx.object.relation.root
 */
@property (nonatomic, strong, readonly) ORCountObjectRelation *rootObjectRelation;

/**
 *  root.home
 */
@property (nonatomic, strong, readonly) ORCountObjectRelation *homeObjectRelation;

/**
 *  root.message
 *  
 *  普通聊天消息 归属于 root.message
 *  domain：root.message.normal.messages ORObjectRelationNormalMessageDomainName
 *  name construct: root.message.normal.messages##chatID    ORMajorKeyCountObjectRelation
 */
@property (nonatomic, strong, readonly) ORCountObjectRelation *messageObjectRelation;

- (ORMajorKeyCountObjectRelation *)normalMessageObjectRelationWithChatID:(NSString *)chatID;

+ (instancetype)sharedManager;

@end

@interface NSObject (BadgeValueObjectRelation)

@property (nonatomic, strong, readonly) ORCountObjectRelation *badgeValueObjectRelation;

@end
