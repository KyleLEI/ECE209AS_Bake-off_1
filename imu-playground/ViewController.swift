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
    
//  @IBOutlet weak var controlView: UIImageView!
    //@IBOutlet weak var ball: UIImageView!
    //var ball:UIImageView!
//    var speedX:UIAccelerationValue = 0
//    var speedY:UIAccelerationValue = 0
    
    
    
    var motion = CMMotionManager()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        print( self.view.bounds.size.width)
        print( self.view.bounds.size.height)
        
        myLabel.text = "fuck it"
        
        //ball = UIImageView(image: UIImage(named: "ball"))
        //ball.bounds = CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth)
        ball.center = self.view.center
        self.view.addSubview(ball)
        
        
//        moveCursor()
        
        
        startDeviceMotion()
    }

    
    
    
//    func moveCursor(){
//        motion.accelerometerUpdateInterval = 1/60
//
//        if motion.isAccelerometerAvailable {
//                   let queue = OperationQueue.current
//                    print("cursor working")
//
//                   motion.startAccelerometerUpdates(to: queue!) { (accelerometerData, error) in
//                       self.speedX += accelerometerData!.acceleration.x
//                       self.speedY += accelerometerData!.acceleration.y
//
//                       var posX = self.ball.center.x + CGFloat(self.speedX)
//                       var posY = self.ball.center.y - CGFloat(self.speedY)
//                       if posX <= ballWidth/2.0 {
//                              posX = ballWidth/2.0
//                              self.speedX *= 0
//                        }else if posX >= self.view.bounds.size.width - ballWidth/2.0 {
//                            posX = self.view.bounds.size.width - ballWidth/2.0
//                            self.speedX *= 0
//                        }
//
//                        if posY <= ballWidth/2.0 {
//                            posY = ballWidth/2.0;
//                            self.speedY *= 0
//                        }else if posY > self.view.bounds.size.height - ballWidth/2.0{
//                            posY = self.view.bounds.size.height - ballWidth/2.0;
//                            self.speedY *= 0
//                        }
//                        self.ball.center = CGPoint(x:posX, y:posY)
//                    }
//        }
//    }
    
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
    
    
    
    

    @IBAction func panCursor(_ sender: UIPanGestureRecognizer){
//        guard let cursorView = self.ball.view else{
//            return
//        }
//       print("pan")
        status.text="pan Detected"
        let translation = sender.translation(in: self.view)
        var posX = self.ball.center.x + translation.x
        var posY = self.ball.center.y + translation.y
        
        let imgUpper = self.img.center.y - self.img.bounds.size.height/2.0
        let imgLower = self.img.center.y + self.img.bounds.size.height/2.0
        
        if posX <= ballWidth/2.0 {
                posX = ballWidth/2.0
        }else if posX >= self.view.bounds.size.width - ballWidth/2.0 {
                posX = self.view.bounds.size.width - ballWidth/2.0
        }
        
        
        if posY <= imgUpper + ballWidth/2.0 {
                posY = imgUpper + ballWidth/2.0
        }else if posY >= imgLower - ballWidth/2.0 {
                posY = imgLower - ballWidth/2.0
        }
        
        
        self.ball.center = CGPoint(x:posX, y:posY)
        
        sender.setTranslation(.zero, in: view)
    }

    @IBAction func tapCursor(_ sender: UITapGestureRecognizer){
        status.text="tap Detected"
        let imgUpper = self.img.center.y - self.img.bounds.size.height/2.0
        //let imgLower = self.img.center.y + self.img.bounds.size.height/2.0
        
        let cellHeight = self.img.bounds.size.height/4.0
        let cellWidth = self.img.bounds.size.width/10.0
        
        var indexX = self.ball.center.x/cellWidth
        indexX = indexX.rounded(.up)
        var indexY = (self.ball.center.y - imgUpper)/cellHeight
        indexY = indexY.rounded(.up)
        
        if indexY == 1.0{
            switch indexX {
            case 1.0:
                print("1")
            case 2.0:
                print("2")
            case 3.0:
                print("3")
            case 4.0:
                print("4")
            case 5.0:
                print("5")
            case 6.0:
                print("6")
            case 7.0:
                print("7")
            case 8.0:
                print("8")
            case 9.0:
                print("9")
            case 10.0:
                print("0")
            default:
                print("nothing")
            }
        }else if indexY == 2.0{
            switch indexX {
            case 1.0:
                print("q")
            case 2.0:
                print("w")
            case 3.0:
                print("e")
            case 4.0:
                print("r")
            case 5.0:
                print("t")
            case 6.0:
                print("y")
            case 7.0:
                print("u")
            case 8.0:
                print("i")
            case 9.0:
                print("o")
            case 10.0:
                print("p")
            default:
                print("nothing")
            }
        }else if indexY == 3.0{
            switch indexX {
            case 1.0:
                print("a")
            case 2.0:
                print("s")
            case 3.0:
                print("d")
            case 4.0:
                print("f")
            case 5.0:
                print("g")
            case 6.0:
                print("h")
            case 7.0:
                print("j")
            case 8.0:
                print("k")
            case 9.0:
                print("l")
            case 10.0:
                print("!")
            default:
                print("nothing")
            }
        }else{
            switch indexX {
            case 1.0:
                print("z")
            case 2.0:
                print("x")
            case 3.0:
                print("c")
            case 4.0:
                print("v")
            case 5.0:
                print("b")
            case 6.0:
                print("n")
            case 7.0:
                print("m")
            case 8.0:
                print(",")
            case 9.0:
                print(".")
            case 10.0:
                print("?")
            default:
                print("nothing")
            }
            
        }
        
               
        
    }








}

