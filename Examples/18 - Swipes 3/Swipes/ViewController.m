//
//  ViewController.m
//  Swipes
//
//  Created by Kim Topley on 7/22/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (NSUInteger touchCount = 1; touchCount <= 5; touchCount++) {
        UISwipeGestureRecognizer *vertical;
        vertical = [[UISwipeGestureRecognizer alloc]
                    initWithTarget:self action:@selector(reportVerticalSwipe:)];
        vertical.direction = UISwipeGestureRecognizerDirectionUp |
                             UISwipeGestureRecognizerDirectionDown;
        vertical.numberOfTouchesRequired = touchCount;
        [self.view addGestureRecognizer:vertical];
        
        UISwipeGestureRecognizer *horizontal;
        horizontal = [[UISwipeGestureRecognizer alloc]
                      initWithTarget:self action:@selector(reportHorizontalSwipe:)];
        horizontal.direction = UISwipeGestureRecognizerDirectionLeft |
                               UISwipeGestureRecognizerDirectionRight;
        horizontal.numberOfTouchesRequired = touchCount;
        [self.view addGestureRecognizer:horizontal];
    }
}

#pragma mark - Touch Handling

- (NSString *)descriptionForTouchCount:(NSUInteger)touchCount {
    switch (touchCount) {
        case 1:
            return @"Single";
        case 2:
            return @"Double";
        case 3:
            return @"Triple";
        case 4:
            return @"Quadruple";
        case 5:
            return @"Quintuple";
        default:
            return @"";
    }
}

- (void)reportHorizontalSwipe:(UIGestureRecognizer *)recognizer {
    self.label.text = [NSString stringWithFormat:@"%@ Horizontal swipe detected",
                [self descriptionForTouchCount:[recognizer numberOfTouches]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{ self.label.text = @""; });
}

- (void)reportVerticalSwipe:(UIGestureRecognizer *)recognizer {
    self.label.text = [NSString stringWithFormat:@"%@ Vertical swipe detected",
                [self descriptionForTouchCount:[recognizer numberOfTouches]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{ self.label.text = @""; });
}

@end
