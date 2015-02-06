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

- (void)displayApplicationState {
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive:
            NSLog(@"UIApplicationStateActive");
            break;
        case UIApplicationStateBackground:
            NSLog(@"UIApplicationStateBackground");
            break;
        case UIApplicationStateInactive:
            NSLog(@"UIApplicationStateInactive");
            break;
        default:
            break;
    }
    NSLog(@"timeRemaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myTimerEnableSwitch.on = NO;
    self.myBackgroundEnableSwitch.on = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//We did this because we want to dynamically respond when someone
// changes the switch.
- (IBAction)doTimerEnableSwitch:(id)sender {
    UISwitch *mySwitch = sender;
    if (mySwitch.on) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
    } else {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (IBAction)doBackgroundEnableSwitch:(id)sender {
    
}

- (void)doTimer:(NSTimer *) timer {
    self.myTimerCount++;
    //By using '_' you are going directly to the value instead of using self.myTimerCount (which is calling a getter).
    self.myTimerCountLabel.text = [NSString stringWithFormat:@"Count = %i", _myTimerCount];
    NSLog(@"Count = %i", self.myTimerCount); //This is the official way.
    [self displayApplicationState];
}

@end
