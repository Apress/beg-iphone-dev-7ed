//
//  ContentCell.h
//  DialogViewer
//
//  Created by Kim Topley on 8/31/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *label;
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) CGFloat maxWidth;

+ (CGSize)sizeForContentString:(NSString *)s forMaxWidth:(CGFloat)maxWidth;

@end
