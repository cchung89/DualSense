//
//  ColorViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/6/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ColorViewController: UIViewController {
    
    internal var name: String?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var colorView: UIImageView!
    
    var seconds = 3
    var timer = Timer()
    var isTimeRunning = false
    var gameStart = false
    var startTimer = 3
    var colorData: ColorData?
    var colorRef: DatabaseReference?
    
    /*
     * Number representation of the color
     * red = 1
     * yellow = 2
     * blue = 3
     * orange = 4
     * green = 5
     * purple = 6
     * white = 0 - default for error
     */
    var nextColor = 0
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = ""
        colorData = ColorData(name: name!)
        colorRef = Database.database().reference().child("Colors")
        colorView.image = UIImage(named: "White.png")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Bye color test")
        timer.invalidate()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ColorViewController.updateStartTimer)), userInfo: nil, repeats: true)
        isTimeRunning = true
    }
    
    @objc func updateStartTimer() {
        if startTimer < 1 {
            timeLabel.text = ""
            getNextColor()
            isTimeRunning = false
            timer.invalidate()
            startTimer = 3
            gameStart = true
            startButton.setTitle("Stop", for: .normal)
        } else {
            startTimer -= 1
            if startTimer == 0 {
                timeLabel.text = "GO!!!"
            } else {
                timeLabel.text = String(startTimer)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func togglePlayStop(_ sender: UIButton) {
        if !isTimeRunning {
            if !gameStart {
                timeLabel.text = String(seconds)
                runTimer()
            } else {
                gameStart = false
                startButton.setTitle("Start", for: .normal)
                colorView.image = UIImage(named: "White.png")
            }
        }
    }
    
    func getNextColor() {
        nextColor = Int(arc4random_uniform(6) + 1)
        switch nextColor {
        case 1:
            colorView.image = UIImage(named: "Red.png")
        case 2:
            colorView.image = UIImage(named: "Yellow.png")
        case 3:
            colorView.image = UIImage(named: "Blue.png")
        case 4:
            colorView.image = UIImage(named: "Orange.png")
        case 5:
            colorView.image = UIImage(named: "Green.png")
        case 6:
            colorView.image = UIImage(named: "Purple.png")
        default: // For error check with RNG number
            colorView.image = UIImage(named: "White.png")
        }
    }
    
    @IBAction func redPress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 1 {
                colorData?.red.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    @IBAction func yellowPress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 2 {
                colorData?.yellow.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    @IBAction func bluePress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 3 {
                colorData?.blue.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    @IBAction func orangePress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 4 {
                colorData?.orange.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    @IBAction func greenPress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 5 {
                colorData?.green.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    @IBAction func purplePress(_ sender: UIButton) {
        if gameStart {
            colorCheck()
            if nextColor == 6 {
                colorData?.purple.success += 1
            }
            colorData?.printResult()
            getNextColor()
        }
    }
    
    // Check which color is it currently when the button is pressed to update the correct color total
    func colorCheck() {
        switch nextColor {
        case 1:
            colorData?.red.total += 1
        case 2:
            colorData?.yellow.total += 1
        case 3:
            colorData?.blue.total += 1
        case 4:
            colorData?.orange.total += 1
        case 5:
            colorData?.green.total += 1
        case 6:
            colorData?.purple.total += 1
        default: // For error check with RNG number
            print("Error updating color total due to wrong nextColor value :\(String(nextColor))")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if gameStart || isTimeRunning {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "colorResult") {
            startButton.setTitle("Start", for: .normal)
            let destVC = segue.destination as! ColorDataViewController
            destVC.colorData = colorData
            storeColorData()
        }
    }
    
    func storeColorData() {
        let name = colorData?.name
        let newColorRef = colorRef?.child(name!)
        newColorRef?.setValue(colorData?.toAnyObject())
    }
}
