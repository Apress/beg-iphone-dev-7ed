//
//  TinyPixView.h
//  TinyPix
//
//  Created by Kim Topley on 8/16/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TinyPixDocument;

@interface TinyPixView : UIView

@property (strong, nonatomic) TinyPixDocument *document;

@end
