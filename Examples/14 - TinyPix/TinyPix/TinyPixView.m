//
//  TinyPixView.m
//  TinyPix
//
//  Created by Kim Topley on 8/16/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "TinyPixView.h"
#import "TinyPixDocument.h"

typedef struct {
    NSUInteger row;
    NSUInteger column;
} GridIndex;

@interface TinyPixView ()

@property (assign, nonatomic) CGSize lastSize;
@property (assign, nonatomic) CGRect gridRect;
@property (assign, nonatomic) CGSize blockSize;
@property (assign, nonatomic) CGFloat gap;
@property (assign, nonatomic) GridIndex selectedBlockIndex;

@end

@implementation TinyPixView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self calculateGridForSize:self.bounds.size];
    _selectedBlockIndex.row = NSNotFound;
    _selectedBlockIndex.column = NSNotFound;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!_document) return;
    
    CGSize size = self.bounds.size;
    if (!CGSizeEqualToSize(size, self.lastSize)) {
        self.lastSize = size;
        [self calculateGridForSize:size];
    }
    
    for (NSUInteger row = 0; row < 8; row++) {
        for (NSUInteger column = 0; column < 8; column++) {
            [self drawBlockAtRow:row column:column];
        }
    }
}

- (void)calculateGridForSize:(CGSize)size {
    CGFloat space = MIN(size.width, size.height);
    _gap = space/57;
    CGFloat cellSide = 6 * _gap;
    _blockSize = CGSizeMake(cellSide, cellSide);
    _gridRect = CGRectMake((size.width - space)/2, (size.height - space)/2, space, space);
}

- (void)drawBlockAtRow:(NSUInteger)row column:(NSUInteger)column {
    CGFloat startX = _gridRect.origin.x + _gap + (_blockSize.width + _gap) * (7 - column) + 1;
    CGFloat startY = _gridRect.origin.y + _gap + (_blockSize.height + _gap) * row + 1;
    CGRect blockFrame = CGRectMake(startX, startY,
                                   _blockSize.width, _blockSize.height);
    UIColor *color = [_document stateAtRow:row column:column] ?
    [UIColor blackColor] : [UIColor whiteColor];
    [color setFill];
    [self.tintColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:blockFrame];
    [path fill];
    [path stroke];
}

- (GridIndex)touchedGridIndexFromTouches:(NSSet *)touches {
    GridIndex result;
    result.row = -1;
    result.column = -1;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(_gridRect, location)) {
        location.x -= _gridRect.origin.x;
        location.y -= _gridRect.origin.y;
        result.column = 8 - (location.x * 8.0 / _gridRect.size.width);
        result.row = location.y * 8.0 / _gridRect.size.height;
    }
    return result;
}

- (void)toggleSelectedBlock {
    if (_selectedBlockIndex.row != -1 && _selectedBlockIndex.column != -1) {
        [_document toggleStateAtRow:_selectedBlockIndex.row
                             column:_selectedBlockIndex.column];
        [[_document.undoManager prepareWithInvocationTarget:_document]
         toggleStateAtRow:_selectedBlockIndex.row column:_selectedBlockIndex.column];
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selectedBlockIndex = [self touchedGridIndexFromTouches:touches];
    [self toggleSelectedBlock];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    GridIndex touched = [self touchedGridIndexFromTouches:touches];
    if (touched.row != _selectedBlockIndex.row
           || touched.column != _selectedBlockIndex.column) {
        _selectedBlockIndex = touched;
        [self toggleSelectedBlock];
    }
}

@end
