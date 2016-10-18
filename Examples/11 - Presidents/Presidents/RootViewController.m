//
//  RootViewController.m
//  Presidents
//
//  Created by Kim Topley on 10/25/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIViewController *spltVC = self.viewControllers[0];
    UITraitCollection *newTraits = self.traitCollection;
    if (newTraits.horizontalSizeClass == UIUserInterfaceSizeClassCompact
            && newTraits.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        UITraitCollection *childTraits = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
        [self setOverrideTraitCollection:childTraits forChildViewController:spltVC];
    } else {
        [self setOverrideTraitCollection:nil forChildViewController:spltVC];
    }
    [super traitCollectionDidChange:previousTraitCollection];
}

@end
