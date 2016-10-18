//
//  SKNode+Extra.m
//  TextShooter
//
//  Created by Kim Topley on 8/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "SKNode+Extra.h"

@implementation SKNode (Extra)

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact {
    // default implementation does nothing
}

- (void)friendlyBumpFrom:(SKNode *)node {
    // default implementation does nothing
}

@end
