//
//  PlayerNode.h
//  TextShooter
//
//  Created by Kim Topley on 8/8/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerNode : SKNode

// returns duration of future movement
- (void)moveToward:(CGPoint)location;

@end
