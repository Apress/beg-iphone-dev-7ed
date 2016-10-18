//
//  DetailViewController.m
//  Presidents
//
//  Created by Kim Topley on 10/22/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "DetailViewController.h"
#import "LanguageListController.h"

@interface DetailViewController () <UIPopoverControllerDelegate>

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

static NSString * modifyUrlForLanguage(NSString *url, NSString *lang) {
    if (!lang) {
        return url;
    }
    
    // We're relying on a particular Wikipedia URL format here. This
    // is a bit fragile!
    // URL is like http://en.wikipedia……
    NSRange codeRange = NSMakeRange(7, 2);
    if ([[url substringWithRange:codeRange] isEqualToString:lang]) {
        return url;
    } else {
        NSString *newUrl = [url stringByReplacingCharactersInRange:codeRange
                                                        withString:lang];
        return newUrl;
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSDictionary *dict = (NSDictionary *)self.detailItem;
        
        NSString *urlString = modifyUrlForLanguage(dict[@"url"], self.languageString);
        self.detailDescriptionLabel.text = urlString;
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];

        NSString *name = dict[@"name"];
        self.title = name;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.languageButton =
             [[UIBarButtonItem alloc] initWithTitle:@"Choose Language"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(toggleLanguagePopover)];
        self.navigationItem.rightBarButtonItem = self.languageButton;
    }
    [self configureView];
}

- (void)toggleLanguagePopover {
    if (self.languagePopoverController == nil) {
        LanguageListController *languageListController =
                [[LanguageListController alloc] init];
        languageListController.detailViewController = self;
        UIPopoverController *poc =
            [[UIPopoverController alloc]
                  initWithContentViewController:languageListController];
        [poc presentPopoverFromBarButtonItem:self.languageButton
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
        self.languagePopoverController = poc;
    } else {
        [self.languagePopoverController dismissPopoverAnimated:YES];
        self.languagePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:
             (UIPopoverController *)popoverController  {
    if (popoverController == self.languagePopoverController) {
        self.languagePopoverController = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setLanguageString:(NSString *)newString {
    if (![newString isEqualToString:self.languageString]) {
        _languageString = [newString copy];
        [self configureView];
    }
    if (self.languagePopoverController != nil) {
        [self.languagePopoverController dismissPopoverAnimated:YES];
        self.languagePopoverController = nil;
    }
}

@end
