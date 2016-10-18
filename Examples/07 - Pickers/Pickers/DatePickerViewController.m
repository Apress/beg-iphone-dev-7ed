//
//  DatePickerViewController.m
//  Pickers
//
//  Created by Kim Topley on 9/7/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *now = [NSDate date];
    [self.datePicker setDate:now animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    NSDate *date = self.datePicker.date;
    NSString *message = [[NSString alloc] initWithFormat:
                         @"The date and time you selected is %@", date];
    UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"Date and Time Selected"
                    message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"That's so true!"
                    style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
