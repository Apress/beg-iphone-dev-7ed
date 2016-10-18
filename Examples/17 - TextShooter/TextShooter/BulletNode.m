//
//  BulletNode.m
//  TextShooter
//
//  Created by Kim Topley on 8/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BulletNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"

@interface BulletNode ()

@property (assign, nonatomic) CGVector thrust;

@end

@implementation BulletNode

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination {
    BulletNode *bullet = [[self alloc] init];
    
    bullet.position = start;
    
    CGVector movement = VectorBetweenPoints(start, destination);
    CGFloat magnitude = VectorLength(movement);
    if (magnitude == 0.0f) return nil;
    
    CGVector scaledMovement = VectorMultiply(movement, 1 / magnitude);
    
    CGFloat thrustMagnitude = 100.0;
    bullet.thrust = VectorMultiply(scaledMovement, thrustMagnitude);
    
    [bullet runAction:[SKAction playSoundFileNamed:@"shoot.wav"
                                 waitForCompletion:NO]];
    
    return bullet;
}

- (instancetype)init {
    if (self = [super init]) {
        SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor = [SKColor blackColor];
        dot.fontSize = 40;
        dot.text = @".";
        [self addChild:dot];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:1];
        body.dynamic = YES;
        body.categoryBitMask = PlayerMissileCategory;
        body.contactTestBitMask = EnemyCategory;
        body.collisionBitMask = EnemyCategory;
        body.fieldBitMask = GravityFieldCategory;
        body.mass = 0.01;
        
        self.physicsBody = body;
        self.name = [NSString stringWithFormat:@"Bullet %p", self];
    }
    return self;
}

- (void)applyRecurringForce {
    [self.physicsBody applyForce:self.thrust];
}

@end
