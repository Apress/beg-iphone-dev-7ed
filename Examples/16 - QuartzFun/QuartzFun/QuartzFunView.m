//
//  QuartzFunView.m
//  QuartzFun
//
//  Created by Kim Topley on 6/19/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "QuartzFunView.h"
#import "UIColor+Random.h"

@interface QuartzFunView ()

@property (assign, nonatomic) CGPoint firstTouchLocation;
@property (assign, nonatomic) CGPoint lastTouchLocation;
@property (strong, nonatomic) UIImage *image;
@property (readonly, nonatomic) CGRect currentRect;
@property (assign, nonatomic) CGRect redrawRect;

@end

@implementation QuartzFunView

- (id)initWithCoder:(NSCoder*)coder {
    if (self = [super initWithCoder:coder]) {
        _currentColor = [UIColor redColor];
        _useRandomColor = NO;
        _image = [UIImage imageNamed:@"iphone"] ;
    }
    return self;
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.useRandomColor) {
        self.currentColor = [UIColor randomColor];
    }
    UITouch *touch = [touches anyObject];
    self.firstTouchLocation = [touch locationInView:self];
    self.lastTouchLocation = [touch locationInView:self];
    self.redrawRect = CGRectZero;
    [self setNeedsDisplay];
}
/*
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 self.lastTouchLocation = [touch locationInView:self];
 
 [self setNeedsDisplay];
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 self.lastTouchLocation = [touch locationInView:self];
 
 [self setNeedsDisplay];
 }
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastTouchLocation = [touch locationInView:self];
    
    if (self.shapeType == kImageShape) {
        CGFloat horizontalOffset = self.image.size.width / 2;
        CGFloat verticalOffset = self.image.size.height / 2;
        self.redrawRect = CGRectUnion(self.redrawRect,
                                      CGRectMake(self.lastTouchLocation.x -
                                                 horizontalOffset,
                                                 self.lastTouchLocation.y -
                                                 verticalOffset,
                                                 self.image.size.width,
                                                 self.image.size.height));
    } else {
        self.redrawRect = CGRectUnion(self.redrawRect, self.currentRect);
    }
    self.redrawRect = CGRectInset(self.redrawRect, -2.0, -2.0);
    [self setNeedsDisplayInRect:self.redrawRect];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.lastTouchLocation = [touch locationInView:self];
    
    if (self.shapeType == kImageShape) {
        CGFloat horizontalOffset = self.image.size.width / 2;
        CGFloat verticalOffset = self.image.size.height / 2;
        self.redrawRect = CGRectUnion(self.redrawRect,
                                      CGRectMake(self.lastTouchLocation.x -
                                                 horizontalOffset,
                                                 self.lastTouchLocation.y -
                                                 verticalOffset,
                                                 self.image.size.width,
                                                 self.image.size.height));
    } else {
        self.redrawRect = CGRectUnion(_redrawRect, self.currentRect);
    }
    [self setNeedsDisplayInRect:self.redrawRect];
}

#pragma mark - Drawing Code

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextSetFillColorWithColor(context, self.currentColor.CGColor);
    /*
     CGRect currentRect = CGRectMake(self.firstTouchLocation.x,
     self.firstTouchLocation.y,
     self.lastTouchLocation.x -
     self.firstTouchLocation.x,
     self.lastTouchLocation.y -
     self.firstTouchLocation.y);
     */
    
    switch (self.shapeType) {
        case kLineShape:
            CGContextMoveToPoint(context,
                                 self.firstTouchLocation.x,
                                 self.firstTouchLocation.y);
            CGContextAddLineToPoint(context,
                                    self.lastTouchLocation.x,
                                    self.lastTouchLocation.y);
            CGContextStrokePath(context);
            break;
        case kRectShape:
            CGContextAddRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kEllipseShape:
            CGContextAddEllipseInRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kImageShape: {
            CGFloat horizontalOffset = self.image.size.width / 2;
            CGFloat verticalOffset = self.image.size.height / 2;
            CGPoint drawPoint = CGPointMake(self.lastTouchLocation.x -
                                            horizontalOffset,
                                            self.lastTouchLocation.y -
                                            verticalOffset);
            [self.image drawAtPoint:drawPoint];
            break;
        }
        default:
            break;
    }
}

- (CGRect)currentRect {
    return CGRectMake (self.firstTouchLocation.x,
                       self.firstTouchLocation.y,
                       self.lastTouchLocation.x - self.firstTouchLocation.x,
                       self.lastTouchLocation.y - self.firstTouchLocation.y);
}


@end
