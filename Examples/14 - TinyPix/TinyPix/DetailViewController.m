//
//  DetailViewController.m
//  TinyPix
//
//  Created by Kim Topley on 8/14/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "DetailViewController.h"
#import "TinyPixView.h"
#import "TinyPixUtils.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet TinyPixView *pixView;

@end

@implementation DetailViewController
            
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    NSLog(@"setDetailItem called, %@", newDetailItem);
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.pixView.document = self.detailItem;
        [self.pixView setNeedsDisplay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self updateTintColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSettingsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIDocument *doc = self.detailItem;
    [doc closeWithCompletionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTintColor {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger selectedColorIndex = [prefs integerForKey:@"selectedColorIndex"];
    UIColor *tintColor = [TinyPixUtils getTintColorForIndex:selectedColorIndex];
    self.pixView .tintColor = tintColor;
    [self.pixView setNeedsDisplay];
}

- (void)onSettingsChanged:(NSNotification *)notification {
    [self updateTintColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

@end
