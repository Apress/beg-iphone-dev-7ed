//
//  PlayerNode.m
//  TextShooter
//
//  Created by Kim Topley on 8/8/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "PlayerNode.h"
#import "Geometry.h"
#import "PhysicsCategories.h"

@implementation PlayerNode

- (instancetype)init {
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"Player %p", self];
        [self initNodeGraph];
        [self initPhysicsBody];
    }
    return self;
}

- (void)initNodeGraph {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.fontColor = [SKColor darkGrayColor];
    label.fontSize = 40;
    label.text = @"v";
    label.zRotation = M_PI;
    label.name = @"label";
    
    [self addChild:label];
    
}

- (void)initPhysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:
                           CGSizeMake(20, 20)];
    body.affectedByGravity = NO;
    body.categoryBitMask = PlayerCategory;
    body.contactTestBitMask = EnemyCategory;
    body.collisionBitMask = 0;
    body.fieldBitMask = 0;
    self.physicsBody = body;
}

- (void)moveToward:(CGPoint)location {
    [self removeActionForKey:@"movement"];
    [self removeActionForKey:@"wobbling"];
    
    CGFloat distance = PointDistance(self.position, location);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 2.0 * distance / screenWidth;
    
    [self runAction:[SKAction moveTo:location duration:duration]
            withKey:@"movement"];
    
    CGFloat wobbleTime = 0.3;
    CGFloat halfWobbleTime = wobbleTime * 0.5;
    SKAction *wobbling = [SKAction
                          sequence:@[[SKAction scaleXTo:0.2
                                               duration:halfWobbleTime],
                                     [SKAction scaleXTo:1.0
                                               duration:halfWobbleTime]
                                     ]];
    NSUInteger wobbleCount = duration / wobbleTime;
    
    [self runAction:[SKAction repeatAction:wobbling count:wobbleCount]
            withKey:@"wobbling"];
}

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion"
                                                     ofType:@"sks"];
    SKEmitterNode *explosion =
                [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 50;
    explosion.position = contact.contactPoint;
    [self.scene addChild:explosion];
    
    [self runAction:[SKAction playSoundFileNamed:@"playerHit.wav"
                               waitForCompletion:NO]];
}


@end
