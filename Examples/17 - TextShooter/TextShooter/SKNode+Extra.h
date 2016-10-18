//
//  SKNode+Extra.h
//  TextShooter
//
//  Created by Kim Topley on 8/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
- (void)friendlyBumpFrom:(SKNode *)node;


@end
