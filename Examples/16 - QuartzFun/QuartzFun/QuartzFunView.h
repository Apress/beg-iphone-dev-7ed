//
//  QuartzFunView.h
//  QuartzFun
//
//  Created by Kim Topley on 6/19/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface QuartzFunView : UIView

@property (assign, nonatomic) ShapeType shapeType;
@property (assign, nonatomic) BOOL useRandomColor;
@property (strong, nonatomic) UIColor *currentColor;

@end
