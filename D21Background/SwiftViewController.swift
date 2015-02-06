//
//  SwiftViewController.swift
//  D21Background
//
//  Created by Rommel Rico on 2/5/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit
import AVFoundation

class SwiftViewController: UIViewController {

    var myAudioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var myAudioSwitch: UISwitch!
    @IBOutlet weak var myAudioLabel: UILabel!
    @IBOutlet weak var myProgressView: UIProgressView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBAction func doStartDownload(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
