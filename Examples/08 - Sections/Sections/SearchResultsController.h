//
//  SearchResultsController.h
//  Sections
//
//  Created by Kim Topley on 10/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsController : UITableViewController <UISearchResultsUpdating>

- (instancetype)initWithNames:(NSDictionary *)names keys:(NSArray *)keys;

@end
