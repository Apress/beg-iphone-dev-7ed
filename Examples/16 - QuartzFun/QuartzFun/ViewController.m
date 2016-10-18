//
//  ViewController.m
//  QuartzFun
//
//  Created by Kim Topley on 6/19/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "QuartzFunView.h"

@interface ViewController ()
            
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorControl;

@end

@implementation ViewController

- (IBAction)changeColor:(UISegmentedControl *)sender {
    QuartzFunView *funView = (QuartzFunView *)self.view;
    ColorTabIndex index = [sender selectedSegmentIndex];
    switch (index) {
        case kRedColorTab:
            funView.currentColor = [UIColor redColor];
            funView.useRandomColor = NO;
            break;
        case kBlueColorTab:
            funView.currentColor = [UIColor blueColor];
            funView.useRandomColor = NO;
            break;
        case kYellowColorTab:
            funView.currentColor = [UIColor yellowColor];
            funView.useRandomColor = NO;
            break;
        case kGreenColorTab:
            funView.currentColor = [UIColor greenColor];
            funView.useRandomColor = NO;
            break;
        case kRandomColorTab:
            funView.useRandomColor = YES;
            break;
        default:
            break;
    }
}

- (IBAction)changeShape:(UISegmentedControl *)sender {
    [(QuartzFunView *)self.view setShapeType:[sender
                                              selectedSegmentIndex]];
    self.colorControl.hidden = [sender selectedSegmentIndex] == kImageShape;
}

@end
