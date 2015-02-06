//
//  ViewController.m
//  D21Background
//
//  Created by Rommel Rico on 2/5/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//These properties allow you to access the state of the switches.
@property (weak, nonatomic) IBOutlet UISwitch *myTimerEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *myBackgroundEnableSwitch;

//This property allows you to access the label and update it.
@property (weak, nonatomic) IBOutlet UILabel *myTimerCountLabel;

//Property for timer count,  NSTimer, and background task id.
@property int myTimerCount;
@property NSTimer *myTimer;
@property UIBackgroundTaskIdentifier myBackgroundTaskID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//We did this because we want to dynamically respond when someone
// changes the switch.
- (IBAction)doTimerEnableSwitch:(id)sender {
}

- (IBAction)doBackgroundEnableSwitch:(id)sender {
}

@end
