//
//  GameOverScene.m
//  TextShooter
//
//  Created by Kim Topley on 8/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "GameOverScene.h"
#import "StartScene.h"

@implementation GameOverScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor purpleColor];
        SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text.text = @"Game Over";
        text.fontColor = [SKColor whiteColor];
        text.fontSize = 50;
        text.position = CGPointMake(self.frame.size.width * 0.5,
                                    self.frame.size.height * 0.5);
        [self addChild:text];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        SKTransition *transition = [SKTransition flipVerticalWithDuration:1.0];
        SKScene *start = [[StartScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:start transition:transition];
    });
}

@end
