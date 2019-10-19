//
//  ViewController.swift
//  imu-playground
//
//  Created by Kyle Lei on 10/7/19.
//  Copyright © 2019 Kyle Lei. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var status: UILabel!
    @IBOutlet var img: UIImageView!
    
    var motion = CMMotionManager()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        myLabel.text = "fuck it"
        startDeviceMotion()
    }

    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    // Get the attitude relative to the magnetic north reference frame.
                                    let x = data.attitude.pitch
                                    let y = data.attitude.roll
                                    let z = data.attitude.yaw
                                    
                                    // Use the motion data in your app.
                                    self.myLabel.text = String(format:"r: %.3f, p: %.3f, y: %.3f",x,y,z)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }else{
            myLabel.text = "Failed to acquire device motion"
        }
    }
    
    @IBAction func buttonStartClick(_ sender: Any){
        print("Touch Down")
//        status.text="Button touched"
//        status.text=""
//        img.centerYAnchor
    }
    
    @IBAction func buttonEndClick(_ sender:Any){
        print("Touch Up")
        status.text=""
    }
    
    @IBAction func swipeLeft(_ sender: UIGestureRecognizer){
        print("Swipe")
        status.text="Swipe Detected"
    }

}

