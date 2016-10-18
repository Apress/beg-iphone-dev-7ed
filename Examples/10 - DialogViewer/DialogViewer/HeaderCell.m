//
//  HeaderCell.m
//  DialogViewer
//
//  Created by Kim Topley on 8/31/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label.backgroundColor = [UIColor colorWithRed:0.9
                                                     green:0.9
                                                      blue:0.8
                                                     alpha:1.0];
        self.label.textColor = [UIColor blackColor];
        
    }
    return self;
}

+ (UIFont *)defaultFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

@end
