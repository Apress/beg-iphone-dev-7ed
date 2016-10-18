//
//  FourLines.h
//  Persistence2
//
//  Created by Kim Topley on 8/1/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourLines : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSArray *lines;

@end
