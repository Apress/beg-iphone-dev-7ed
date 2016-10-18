//
//  ViewController.m
//  View Switcher
//
//  Created by Kim Topley on 9/6/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "SwitchingViewController.h"
#import "YellowViewController.h"
#import "BlueViewController.h"

@interface SwitchingViewController ()

@property (strong, nonatomic) YellowViewController *yellowViewController;
@property (strong, nonatomic) BlueViewController *blueViewController;

@end

@implementation SwitchingViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.blueViewController = [self.storyboard
                               instantiateViewControllerWithIdentifier:
                               @"Blue"];
    
    self.blueViewController.view.frame = self.view.frame;
    [self switchViewFromViewController:nil toViewController:self.blueViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.blueViewController.view.superview) {
        self.blueViewController = nil;
    } else {
        self.yellowViewController = nil;
    }
}

- (IBAction)switchViews:(id)sender {
    // Create the new view controller, if required.
    if (!self.yellowViewController.view.superview) {
        if (!self.yellowViewController) {
            self.yellowViewController = [self.storyboard
                                         instantiateViewControllerWithIdentifier:@"Yellow"];
        }
    } else {
        if (!self.blueViewController) {
            self.blueViewController = [self.storyboard
                                       instantiateViewControllerWithIdentifier:@"Blue"];
        }
    }
    
    // Switch view controllers.
    [UIView beginAnimations:@"View Flip" context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (!self.yellowViewController.view.superview) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                         forView:self.view cache:YES];
        self.yellowViewController.view.frame = self.view.frame;
        [self switchViewFromViewController:self.blueViewController toViewController:self.yellowViewController];
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                         forView:self.view cache:YES];
        self.blueViewController.view.frame = self.view.frame;
        [self switchViewFromViewController:self.yellowViewController toViewController:self.blueViewController];
    }
    [UIView commitAnimations];
}

- (void)switchViewFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (fromVC != nil) {
        [fromVC willMoveToParentViewController:nil];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
    }
    
    if (toVC != nil) {
        [self addChildViewController:toVC];
        [self.view insertSubview:toVC.view atIndex:0];
        [toVC didMoveToParentViewController:self];
    }
}

@end
