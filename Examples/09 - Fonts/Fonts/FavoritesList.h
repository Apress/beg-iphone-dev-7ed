//
//  FavoritesList.h
//  Fonts
//
//  Created by Kim Topley on 10/11/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesList : NSObject

+ (instancetype)sharedFavoritesList;

- (NSArray *)favorites;

- (void)addFavorite:(id)item;
- (void)removeFavorite:(id)item;
- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;

@end
