//
//  SwiftViewController.swift
//  D21Background
//
//  Created by Rommel Rico on 2/5/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {
//myAudioSwitch
    //myAudioLabel
    //myProgressView
    //doAudioSwitch
    @IBOutlet weak var myAudioSwitch: UISwitch!
    @IBOutlet weak var myAudioLabel: UILabel!
    @IBOutlet weak var myProgressView: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doAudioSwitch(sender: AnyObject) {
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
