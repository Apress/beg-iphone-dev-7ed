//
//  ViewController.m
//  MotionMonitor
//
//  Created by Kim Topley on 7/5/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
            
@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;

@property (retain, nonatomic) CMMotionManager *motionManager;
@property (retain, nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesToQueue:self.queue
            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                CMRotationRate rotationRate = motion.rotationRate;
                CMAcceleration gravity = motion.gravity;
                CMAcceleration userAcc = motion.userAcceleration;
                CMAttitude *attitude = motion.attitude;
                
                NSString *gyroscopeText = [NSString stringWithFormat:
                                           @"Rotation Rate:\n-----------------\n"
                                           "x: %+.2f\ny: %+.2f\nz: %+.2f\n",
                                           rotationRate.x, rotationRate.y, rotationRate.z];
                NSString *acceleratorText = [NSString stringWithFormat:
                                             @"Acceleration:\n---------------\n"
                                             "Gravity x: %+.2f\t\tUser x: %+.2f\n"
                                             "Gravity y: %+.2f\t\tUser y: %+.2f\n"
                                             "Gravity z: %+.2f\t\tUser z: %+.2f\n",
                                             gravity.x, userAcc.x, gravity.y,
                                             userAcc.y, gravity.z,userAcc.z];
                NSString *attitudeText = [NSString stringWithFormat:
                                          @"Attitude:\n----------\n"
                                          "Roll: %+.2f\nPitch: %+.2f\nYaw: %+.2f\n",
                                          attitude.roll, attitude.pitch, attitude.yaw];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.gyroscopeLabel.text = gyroscopeText;
                    self.accelerometerLabel.text = acceleratorText;
                    self.attitudeLabel.text = attitudeText;
                });
            }];
    }
}

@end
