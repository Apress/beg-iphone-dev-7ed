//
//  GameScene.m
//  TextShooter
//
//  Created by Kim Topley on 8/5/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "GameScene.h"
#import "PlayerNode.h"
#import "EnemyNode.h"
#import "BulletNode.h"
#import "SKNode+Extra.h"
#import "GameOverScene.h"
#import "PhysicsCategories.h" // XX

@interface GameScene () <SKPhysicsContactDelegate>

@property (strong, nonatomic) PlayerNode *playerNode;
@property (strong, nonatomic) SKNode *enemies;
@property (strong, nonatomic) SKNode *playerBullets;
@property (strong, nonatomic) SKNode *forceFields;

@end

@implementation GameScene

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    return [[self alloc] initWithSize:size levelNumber:levelNumber];
}

- (instancetype)initWithSize:(CGSize)size {
    return [self initWithSize:size levelNumber:1];
}

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    if (self = [super initWithSize:size]) {
        _levelNumber = levelNumber;
        _playerLives = 5;
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        lives.fontSize = 16;
        lives.fontColor = [SKColor blackColor];
        lives.name = @"LivesLabel";
        lives.text = [NSString stringWithFormat:@"Lives: %lu",
                      (unsigned long)_playerLives];
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lives.position = CGPointMake(self.frame.size.width,
                                     self.frame.size.height);
        [self addChild:lives];
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        level.fontSize = 16;
        level.fontColor = [SKColor blackColor];
        level.name = @"LevelLabel";
        level.text = [NSString stringWithFormat:@"Level: %lu",
                      (unsigned long)_levelNumber];
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        level.position = CGPointMake(0, self.frame.size.height);
        [self addChild:level];
        
        _playerNode = [PlayerNode node];
        _playerNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetHeight(self.frame) * 0.1);
        
        [self addChild:_playerNode];
        _enemies = [SKNode node];
        [self addChild:_enemies];
        [self spawnEnemies];
        
        _playerBullets = [SKNode node];
        [self addChild:_playerBullets];
        
        _forceFields = [SKNode node];
        [self addChild:_forceFields];
        [self createForceFields];
        
        self.physicsWorld.gravity = CGVectorMake(0, -1);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.y < CGRectGetHeight(self.frame) * 0.2 ) {
            CGPoint target = CGPointMake(location.x,
                                         self.playerNode.position.y);
            [self.playerNode moveToward:target];
        } else {
            BulletNode *bullet = [BulletNode
                                  bulletFrom:self.playerNode.position
                                  toward:location];
            [self.playerBullets addChild:bullet];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.finished) return;
    
    [self updateBullets];
    [self updateEnemies];
    if (![self checkForGameOver]) {
        [self checkForNextLevel];
    }
}

- (void)updateBullets {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for (BulletNode *bullet in self.playerBullets.children) {
        // Remove any bullets that have moved off-screen
        if (!CGRectContainsPoint(self.frame, bullet.position)) {
            // mark bullet for removal
            [bulletsToRemove addObject:bullet];
            continue;
        }
        
        // Apply thrust to remaining bullets
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}

- (void)spawnEnemies {
    NSUInteger count = log(self.levelNumber) + self.levelNumber;
    for (NSUInteger i = 0; i < count; i++) {
        EnemyNode *enemy = [EnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = arc4random_uniform(size.width * 0.8) + (size.width * 0.1);
        CGFloat y = arc4random_uniform(size.height * 0.5) + (size.height * 0.5);
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}

- (void)updateEnemies {
    NSMutableArray *enemiesToRemove = [NSMutableArray array];
    for (SKNode *node in self.enemies.children) {
        // Remove any enemies that have moved off-screen
        if (!CGRectContainsPoint(self.frame, node.position)) {
            // mark enemy for removal
            [enemiesToRemove addObject:node];
            continue;
        }
    }
    if ([enemiesToRemove count] > 0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}

- (void)checkForNextLevel {
    if ([self.enemies.children count] == 0) {
        [self goToNextLevel];
    }
}

- (void)goToNextLevel {
    self.finished = YES;
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = @"Level Complete!";
    label.fontColor = [SKColor blueColor];
    label.fontSize = 32;
    label.position = CGPointMake(self.frame.size.width * 0.5,
                                 self.frame.size.height * 0.5);
    [self addChild:label];
    
    GameScene *nextLevel = [[GameScene alloc]
                            initWithSize:self.frame.size
                            levelNumber:self.levelNumber + 1];
    nextLevel.playerLives = self.playerLives;
    [self.view presentScene:nextLevel
                 transition:[SKTransition flipHorizontalWithDuration:1.0]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        // Both bodies are in the same category
        SKNode *nodeA = contact.bodyA.node;
        SKNode *nodeB = contact.bodyB.node;
        
        // What do we do with these nodes?
        [nodeA friendlyBumpFrom:nodeB];
        [nodeB friendlyBumpFrom:nodeA];
    } else {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            // Body A is attacking Body B
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        } else {
            // Body B is attacking Body A
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        if ([attackee isKindOfClass:[PlayerNode class]]) {
            self.playerLives--;
        }
        // What do we do with the attacker and the attackee?
        [attackee receiveAttacker:attacker contact:contact];
        [self.playerBullets removeChildrenInArray:@[attacker]];
        [self.enemies removeChildrenInArray:@[attacker]];
    }
}

- (void)setPlayerLives:(NSUInteger)playerLives  {
    _playerLives = playerLives;
    SKLabelNode *lives = (id)[self childNodeWithName:@"LivesLabel"];
    lives.text = [NSString stringWithFormat:@"Lives: %lu",
                  (unsigned long)_playerLives];
}

- (void)triggerGameOver {
    self.finished = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion"
                                                     ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 200;
    explosion.position = _playerNode.position;
    [self addChild:explosion];
    [_playerNode removeFromParent];
    
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *gameOver = [[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transition];
    
    [self runAction:[SKAction playSoundFileNamed:@"gameOver.wav"
                               waitForCompletion:NO]];
}

- (BOOL)checkForGameOver {
    if (self.playerLives == 0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}

- (void)createForceFields {
    static int fieldCount = 3;
    CGSize size = self.frame.size;
    float sectionWidth = size.width/fieldCount;
    for (NSUInteger i = 0; i < fieldCount; i++) {
        CGFloat x = i * sectionWidth + arc4random_uniform(sectionWidth);
        CGFloat y = arc4random_uniform(size.height * 0.25) + (size.height * 0.25);
        
        SKFieldNode *gravityField = [SKFieldNode radialGravityField];
        gravityField.position = CGPointMake(x, y);
        gravityField.categoryBitMask = GravityFieldCategory;
        gravityField.strength = 4;
        gravityField.falloff = 2;
        gravityField.region = [[SKRegion alloc]
                    initWithSize:CGSizeMake(size.width * 0.3, size.height * 0.1)];
        [self.forceFields addChild:gravityField];
        
        SKLabelNode *fieldLocationNode = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        fieldLocationNode.fontSize = 16;
        fieldLocationNode.fontColor = [SKColor redColor];
        fieldLocationNode.name = @"GravityField";
        fieldLocationNode.text = @"*";
        fieldLocationNode.position = CGPointMake(x, y);
        [self.forceFields addChild:fieldLocationNode];
    }
}

@end
