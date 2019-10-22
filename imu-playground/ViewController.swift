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
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var textbox: UITextView!
    
    var motion = CMMotionManager()
    var timer = Timer()
    var isCaptalized:Bool = false;
    var panSpeed:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello")
        print( self.view.bounds.size.width)
        print( self.view.bounds.size.height)
        
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
    }
    
    @IBAction func buttonEndClick(_ sender:UIButton){
        print("Touch Up")
        insert(char: "a")
    }
    
    func insert(char:String){
//        textbox.text = String(textbox.text) +
//            (isCaptalized ? char.capitalized:char)
//        textbox.insertText(isCaptalized ? char.capitalized:char)
        textbox.text = String(textbox.text) + (isCaptalized ? char.capitalized:char)
        print("Inserted "+(isCaptalized ? char.capitalized:char))
        
    }
    
    func backspace(){
        textbox.text = String(textbox.text.dropLast())
    }
    
    @IBAction func swipeLeft(_ sender: UIGestureRecognizer){
        print("Swipe Left")
        backspace()
    }

    @IBAction func panCursor(_ sender: UIPanGestureRecognizer){
//        guard let cursorView = self.ball.view else{
//            return
//        }
//       print("pan")
        let translation = sender.translation(in: self.view)
        var posX = self.ball.center.x + panSpeed*translation.x
        var posY = self.ball.center.y + panSpeed*translation.y
        
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
        print("tap Detected")
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
                insert(char: "1")
            case 2.0:
                insert(char: "2")
            case 3.0:
                insert(char: "3")
            case 4.0:
                insert(char: "4")
            case 5.0:
                insert(char: "5")
            case 6.0:
                insert(char: "6")
            case 7.0:
                insert(char: "7")
            case 8.0:
                insert(char: "8")
            case 9.0:
                insert(char: "9")
            case 10.0:
                insert(char: "0")
            default:
                insert(char: "nothing")
            }
        }else if indexY == 2.0{
            switch indexX {
            case 1.0:
                insert(char: "q")
            case 2.0:
                insert(char: "w")
            case 3.0:
                insert(char: "e")
            case 4.0:
                insert(char: "r")
            case 5.0:
                insert(char: "t")
            case 6.0:
                insert(char: "y")
            case 7.0:
                insert(char: "u")
            case 8.0:
                insert(char: "i")
            case 9.0:
                insert(char: "o")
            case 10.0:
                insert(char: "p")
            default:
                insert(char: "nothing")
            }
        }else if indexY == 3.0{
            switch indexX {
            case 1.0:
                insert(char: "a")
            case 2.0:
                insert(char: "s")
            case 3.0:
                insert(char: "d")
            case 4.0:
                insert(char: "f")
            case 5.0:
                insert(char: "g")
            case 6.0:
                insert(char: "h")
            case 7.0:
                insert(char: "j")
            case 8.0:
                insert(char: "k")
            case 9.0:
                insert(char: "l")
            case 10.0:
                insert(char: "!")
            default:
                insert(char: "nothing")
            }
        }else{
            switch indexX {
            case 1.0:
                insert(char: "z")
            case 2.0:
                insert(char: "x")
            case 3.0:
                insert(char: "c")
            case 4.0:
                insert(char: "v")
            case 5.0:
                insert(char: "b")
            case 6.0:
                insert(char: "n")
            case 7.0:
                insert(char: "m")
            case 8.0:
                insert(char: ",")
            case 9.0:
                insert(char: ".")
            case 10.0:
                insert(char: "?")
            default:
                insert(char: "nothing")
            }
            
        }
        
               
        
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        /* Insert a space */
        print("Swipe Right")
        insert(char: " ")
    }
    
    @IBOutlet weak var capSwitch: UISwitch!
    var prevIsCaped:Bool = false;
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state==UIGestureRecognizer.State.began {
            /* Add a capitalized character */
            print("Long Press")
            // preserve the previous capitalization state
            
        }else if sender.state==UIGestureRecognizer.State.ended{
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
                    insert(char: "1")
                case 2.0:
                    insert(char: "2")
                case 3.0:
                    insert(char: "3")
                case 4.0:
                    insert(char: "4")
                case 5.0:
                    insert(char: "5")
                case 6.0:
                    insert(char: "6")
                case 7.0:
                    insert(char: "7")
                case 8.0:
                    insert(char: "8")
                case 9.0:
                    insert(char: "9")
                case 10.0:
                    insert(char: "0")
                default:
                    insert(char: "nothing")
                }
            }else if indexY == 2.0{
                switch indexX {
                case 1.0:
                    insert(char: "Q")
                case 2.0:
                    insert(char: "W")
                case 3.0:
                    insert(char: "E")
                case 4.0:
                    insert(char: "R")
                case 5.0:
                    insert(char: "T")
                case 6.0:
                    insert(char: "Y")
                case 7.0:
                    insert(char: "U")
                case 8.0:
                    insert(char: "I")
                case 9.0:
                    insert(char: "O")
                case 10.0:
                    insert(char: "P")
                default:
                    insert(char: "nothing")
                }
            }else if indexY == 3.0{
                switch indexX {
                case 1.0:
                    insert(char: "A")
                case 2.0:
                    insert(char: "S")
                case 3.0:
                    insert(char: "D")
                case 4.0:
                    insert(char: "F")
                case 5.0:
                    insert(char: "G")
                case 6.0:
                    insert(char: "H")
                case 7.0:
                    insert(char: "J")
                case 8.0:
                    insert(char: "K")
                case 9.0:
                    insert(char: "L")
                case 10.0:
                    insert(char: "!")
                default:
                    insert(char: "nothing")
                }
            }else{
                switch indexX {
                case 1.0:
                    insert(char: "Z")
                case 2.0:
                    insert(char: "X")
                case 3.0:
                    insert(char: "C")
                case 4.0:
                    insert(char: "V")
                case 5.0:
                    insert(char: "B")
                case 6.0:
                    insert(char: "N")
                case 7.0:
                    insert(char: "M")
                case 8.0:
                    insert(char: ",")
                case 9.0:
                    insert(char: ".")
                case 10.0:
                    insert(char: "?")
                default:
                    insert(char: "nothing")
                }
            }
            print("Long Press End")
        }else{
            /* Ignore repeated long press events */
            return
        }
        
    }
    @IBAction func changeMode(_ sender: UISwitch) {
        /* Adjust capitalizaiton state based on the switch position */
        if(sender.isOn){
            print("Switch On")
            isCaptalized = true
        }else{
            print("Switch Off")
            isCaptalized = false
        }
    }
    @IBAction func sliderCallback(_ sender: UISlider) {
        print(sender.value)
        panSpeed = CGFloat(sender.value * 2 + 1.0)
    }
}

