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
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        int count = 0;
        while (1) {
            count++;
            sleep(2);
            NSLog(@"Thread count = %i", count);
        }
    });
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
        NSLog(@"mySwitch is on");
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
    } else {
        NSLog(@"mySwitch is off");
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (IBAction)doBackgroundEnableSwitch:(id)sender {
    UISwitch *mySwitch = sender;
    if (mySwitch.on) {
        self.myBackgroundTaskID = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"WE RAN OUT OF TIME!");
            //abort(); //Crash if we get here. (not necessary because we ran out of time.
        }];
        NSLog(@"MyBackgroundTaskID = %lu", self.myBackgroundTaskID);
    } else {
        [[UIApplication sharedApplication]endBackgroundTask:self.myBackgroundTaskID];
    }
}

- (void)doTimer:(NSTimer *)timer {
    self.myTimerCount++;
    //By using '_' you are going directly to the value instead of using self.myTimerCount (which is calling a getter).
    self.myTimerCountLabel.text = [NSString stringWithFormat:@"Count = %i", _myTimerCount];
    NSLog(@"Count = %i", self.myTimerCount); //This is the official way.
    [self displayApplicationState];
}

@end
