//
//  SwiftViewController.swift
//  D21Background
//
//  Created by Rommel Rico on 2/5/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import AVFoundation

class SwiftViewController: UIViewController, NSURLSessionDownloadDelegate {

    var myAudioPlayer: AVAudioPlayer!
    var myTimerCount = 0
    var myTimer: NSTimer?
    
    @IBOutlet weak var myTimerCountLabel: UILabel!
    @IBOutlet weak var myTimerEnableSwitch: UISwitch!
    @IBOutlet weak var myBackgroundEnableSwitch: UISwitch!
    @IBOutlet weak var myAudioSwitch: UISwitch!
    @IBOutlet weak var myAudioLabel: UILabel!
    @IBOutlet weak var myProgressView: UIProgressView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBAction func doTimerEnableSwitch(sender: AnyObject) {
        let swtch = sender as UISwitch
        if swtch.on {
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"doTimer:", userInfo:nil, repeats:true)
        } else {
            myTimer?.invalidate()
            myTimer = nil
        }
    }
    
    
    var myBackgroundTaskID = UIBackgroundTaskInvalid
    @IBAction func doBackgroundEnableSwitch(sender: AnyObject) {
        var swtch = sender as UISwitch
        if swtch.on {
            myBackgroundTaskID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                //Nothing to do
                NSLog("Here")
                //abort()
            })
        } else {
            UIApplication.sharedApplication().endBackgroundTask(myBackgroundTaskID)
        }

    }
    
    func displayApplicationState() {
        switch UIApplication.sharedApplication().applicationState {
        case UIApplicationState.Active:
            NSLog("UIApplicationState.Active")
        case UIApplicationState.Background:
            NSLog("UIApplicationState.Background")
        case UIApplicationState.Inactive:
            NSLog("UIApplicationState.Inactive")
        }
    }
    
    func doTimer(timer: NSTimer!) {
        myTimerCount++
        let s = "Timer Count: " + String(myTimerCount)
        displayApplicationState()
        NSLog(s)
    }
    
    @IBAction func doStartDownload(sender: AnyObject) {
        //FOR TEST ONLY
        sleep(2)
        //END TEST
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.rommelrico.session")
        config.sessionSendsLaunchEvents = true
        config.discretionary = true
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let url = NSURL(string:"http://www.apple.com")
        let downloadTask = session.downloadTaskWithURL(url!)
        downloadTask.resume()
        myTextView.text = "Starting the download..."
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        NSLog("Session: %@", session)
        NSLog("Location: %@", location)
        NSLog("Download Task: %@", downloadTask)
        
        let html = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil)
        //Make sure this is on main thread
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTextView.text = html
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTimerEnableSwitch.on = false
        myBackgroundEnableSwitch.on = false
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            //Simulate doing work
            var count = 0
            while true {
                count++
                sleep(2)
                NSLog("backgroundTimeRemaining: %i", UIApplication.sharedApplication().backgroundTimeRemaining)
                NSLog("count: %i", count)
            }
        })
        
        let myUrl = NSBundle.mainBundle().URLForResource("fight-torreros-full", withExtension: "mp3")
        var myError: NSError?
        myAudioPlayer = AVAudioPlayer(contentsOfURL: myUrl, error: &myError)
        if let error = myError {
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
        } else { //No error
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &myError)
            AVAudioSession.sharedInstance().setActive(true, error: &myError)
            //TODO Error handling
        }
        myAudioSwitch.on = false
        updateAudioInfo()
    }
    
    func updateAudioInfo() {
        myAudioLabel.text = "Duration: \(myAudioPlayer.duration), Current: \(myAudioPlayer.currentTime)"
        myProgressView.progress = Float(myAudioPlayer.currentTime) / Float(myAudioPlayer.duration)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doAudioSwitch(sender: AnyObject) {
        let mySwitch = sender as UISwitch
        if mySwitch.on {
            myAudioPlayer.play()
            updateAudioInfo()
        } else {
            myAudioPlayer.pause()
            updateAudioInfo()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
