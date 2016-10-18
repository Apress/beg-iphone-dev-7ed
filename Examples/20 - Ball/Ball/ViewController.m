//
//  ViewController.m
//  Ball
//
//  Created by Kim Topley on 7/5/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval    (1.0f / 60.0f)

@interface ViewController ()
            
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    self.motionManager.deviceMotionUpdateInterval = kUpdateInterval;
    __weak ViewController *weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler: ^(CMDeviceMotion *motionData, NSError *error) {
            BallView *ballView = (BallView *)weakSelf.view;
            [ballView setAcceleration:motionData.gravity];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ballView update];
            });
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
