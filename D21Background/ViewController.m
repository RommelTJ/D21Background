//
//  ViewController.m
//  D21Background
//
//  Created by Rommel Rico on 2/5/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController () <NSURLSessionDownloadDelegate>

//These properties allow you to access the state of the switches.
@property (weak, nonatomic) IBOutlet UISwitch *myTimerEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *myBackgroundEnableSwitch;

//This property allows you to access the label and update it.
@property (weak, nonatomic) IBOutlet UILabel *myTimerCountLabel;

//Property for timer count,  NSTimer, and background task id.
@property int myTimerCount;
@property NSTimer *myTimer;
@property UIBackgroundTaskIdentifier myBackgroundTaskID;

@property (weak, nonatomic) IBOutlet UIButton *myStartStopButton;
@property (weak, nonatomic) IBOutlet UILabel *myAudioDurationLabel;
@property AVAudioPlayer *myAudioPlayer;

@property (weak, nonatomic) IBOutlet UIButton *myDownloadFileButton;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;


@end

@implementation ViewController

- (IBAction)doDownloadFile:(id)sender {
    NSURLSessionConfiguration *sc;
    NSLog(@"%i", __IPHONE_OS_VERSION_MIN_REQUIRED);
    NSLog(@"%i", __IPHONE_7_1);
    NSLog(@"%i", __IPHONE_8_0);
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
    sc = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.rommelrico.session"];
#else 
    sc = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.rommelrico.session"];
#endif
    
    sc.sessionSendsLaunchEvents = YES;
    sc.discretionary = YES;
    
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:sc];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sc delegate:self delegateQueue:nil];
    
    NSURL *myUrl = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:myUrl];
    
    [downloadTask resume];
    self.myTextView.text = [downloadTask description];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"Session: %@", session);
    NSLog(@"Location: %@", location);
    NSLog(@"Download Task: %@", downloadTask);
    
    //Read the file into a string
    NSError *myError = nil;
    NSString *s = [NSString stringWithContentsOfFile:location.path encoding:NSUTF8StringEncoding error:&myError];
    
    //Make sure this is on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myTextView.text = s;
    });
}

- (void)updateAudioLabel {
    self.myAudioDurationLabel.text = [NSString stringWithFormat:@"Duration: %f, Current: %f",
                                      self.myAudioPlayer.duration, self.myAudioPlayer.currentTime];
}

- (IBAction)doStartStopAudioButton:(id)sender {
    if(self.myAudioPlayer.isPlaying) {
        //Pause audio
        [self.myAudioPlayer pause];
        [self updateAudioLabel];
    } else {
        //Start audio
        [self.myAudioPlayer play];
        [self updateAudioLabel];
    }
}

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
    //Log this to a file to test beginBackgroundTaskWithExpirationHandler
    NSString *myString = [NSString stringWithFormat:@"Time Remaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining];
    [self writeToLogFile:myString];
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
    
    //Load in audio file
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"fight-torreros-full" withExtension:@"mp3"];
    NSError *myError = nil;
    self.myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&myError];
    if(myError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audio Error" message:[myError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    self.myTextView.text = @"";
    self.myTextView.editable = NO;
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
            
            //Log this to a file to test beginBackgroundTaskWithExpirationHandler
            NSString *myString = @"We ran out of time!!!";
            [self writeToLogFile:myString];
        }];
        NSLog(@"MyBackgroundTaskID = %lu", self.myBackgroundTaskID);
    } else {
        [[UIApplication sharedApplication]endBackgroundTask:self.myBackgroundTaskID];
    }
}

- (void)writeToLogFile:(NSString*)content{
    content = [NSString stringWithFormat:@"%@\n",content];
    
    //get the documents directory:
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"data5.txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
}

- (void)doTimer:(NSTimer *)timer {
    self.myTimerCount++;
    //By using '_' you are going directly to the value instead of using self.myTimerCount (which is calling a getter).
    self.myTimerCountLabel.text = [NSString stringWithFormat:@"Count = %i", _myTimerCount];
    NSLog(@"Count = %i", self.myTimerCount); //This is the official way.
    
    //Log this to a file to test beginBackgroundTaskWithExpirationHandler
    NSString *myString = [NSString stringWithFormat:@"Count is: %d", self.myTimerCount];
    [self writeToLogFile:myString];
    
    [self displayApplicationState];
}

@end
