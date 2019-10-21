//
//  ViewController.swift
//  imu-playground
//
//  Created by Kyle Lei on 10/7/19.
//  Copyright © 2019 Kyle Lei. All rights reserved.
//

import UIKit
import CoreMotion

let ballWidth:CGFloat = 25

class ViewController: UIViewController {
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var status: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    //@IBOutlet weak var ball: UIImageView!
    //var ball:UIImageView!
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    
    var motion = CMMotionManager()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        myLabel.text = "fuck it"
        
        //ball = UIImageView(image: UIImage(named: "ball"))
        //ball.bounds = CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth)
        ball.center = self.view.center
        self.view.addSubview(ball)
        
        
        moveCursor()
        
        
        
        
        startDeviceMotion()
    }

    
    
    
    func moveCursor(){
        motion.accelerometerUpdateInterval = 1/60
        
        if motion.isAccelerometerAvailable {
                   let queue = OperationQueue.current
                    print("cursor working")
                   
                   motion.startAccelerometerUpdates(to: queue!) { (accelerometerData, error) in
                       //动态设置小球位置
                       self.speedX += accelerometerData!.acceleration.x
                       self.speedY += accelerometerData!.acceleration.y
                       
                       var posX = self.ball.center.x + CGFloat(self.speedX)
                       var posY = self.ball.center.y - CGFloat(self.speedY)
                       if posX <= ballWidth/2.0 {
                              posX = ballWidth/2.0
                              self.speedX *= 0
                        }else if posX >= self.view.bounds.size.width - ballWidth/2.0 {
                            posX = self.view.bounds.size.width - ballWidth/2.0
                            self.speedX *= 0
                        }
                        
                        if posY <= ballWidth/2.0 {
                            posY = ballWidth/2.0;
                            self.speedY *= 0
                        }else if posY > self.view.bounds.size.height - ballWidth/2.0{
                            posY = self.view.bounds.size.height - ballWidth/2.0;
                            self.speedY *= 0
                        }
                        self.ball.center = CGPoint(x:posX, y:posY)
                    }
        }
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

