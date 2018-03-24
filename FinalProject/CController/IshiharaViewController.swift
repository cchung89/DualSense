//
//  IshiharaViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/23/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit

class IshiharaViewController: UIViewController {
    
    @IBOutlet weak var plateView: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    var plateNumber = 0
    var correctButton = 1
    var redColorBlind = 0
    var greenColorBlind = 0
    var redGreenColorBlind = 0
    var totalColorBlind = 0
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plateView.image = UIImage(named: "Plate1.gif")
        correctLabel.text = ""
        conditionLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setPlate() {
        switch(plateNumber) {
        case 0:
            plateView.image = UIImage(named: "Plate1.gif")
            correctButton = 1
            redGreenColorBlind = 0
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 0
            firstButton.setTitle("12", for: .normal)
            secondButton.setTitle("1", for: .normal)
            thirdButton.setTitle("2", for: .normal)
            fourthButton.setTitle("None", for: .normal)
        case 1:
            plateView.image = UIImage(named: "Plate2.gif")
            correctButton = 4
            redGreenColorBlind = 1
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 3
            firstButton.setTitle("3", for: .normal)
            secondButton.setTitle("0", for: .normal)
            thirdButton.setTitle("None", for: .normal)
            fourthButton.setTitle("8", for: .normal)
        case 2:
            plateView.image = UIImage(named: "Plate3.gif")
            correctButton = 3
            redGreenColorBlind = 2
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 4
            firstButton.setTitle("7", for: .normal)
            secondButton.setTitle("21", for: .normal)
            thirdButton.setTitle("74", for: .normal)
            fourthButton.setTitle("None", for: .normal)
        case 3:
            plateView.image = UIImage(named: "Plate4.gif")
            correctButton = 2
            redGreenColorBlind = 0
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 3
            firstButton.setTitle("0", for: .normal)
            secondButton.setTitle("6", for: .normal)
            thirdButton.setTitle("None", for: .normal)
            fourthButton.setTitle("5", for: .normal)
        case 4:
            plateView.image = UIImage(named: "Plate5.gif")
            correctButton = 4
            redGreenColorBlind = 0
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 1
            firstButton.setTitle("None", for: .normal)
            secondButton.setTitle("78", for: .normal)
            thirdButton.setTitle("23", for: .normal)
            fourthButton.setTitle("73", for: .normal)
        case 5:
            plateView.image = UIImage(named: "Plate6.gif")
            correctButton = 1
            redGreenColorBlind = 2
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 0
            firstButton.setTitle("None", for: .normal)
            secondButton.setTitle("5", for: .normal)
            thirdButton.setTitle("4", for: .normal)
            fourthButton.setTitle("40", for: .normal)
        case 6:
            plateView.image = UIImage(named: "Plate7.gif")
            correctButton = 3
            redGreenColorBlind = 0
            redColorBlind = 4
            greenColorBlind = 1
            totalColorBlind = 0
            firstButton.setTitle("2", for: .normal)
            secondButton.setTitle("None", for: .normal)
            thirdButton.setTitle("26", for: .normal)
            fourthButton.setTitle("6", for: .normal)
        default:
            plateView.image = UIImage(named: "Plate1.gif")
            correctButton = 1
            redGreenColorBlind = 0
            redColorBlind = 0
            greenColorBlind = 0
            totalColorBlind = 0
            firstButton.setTitle("12", for: .normal)
            secondButton.setTitle("1", for: .normal)
            thirdButton.setTitle("2", for: .normal)
            fourthButton.setTitle("None", for: .normal)
        }
    }
    
    func colorChoice(_ num: Int) {
        if correctButton == num {
            correctLabel.text = "Correct!!!"
            conditionLabel.text = "Normal"
        } else {
            correctLabel.text = "Wrong!!!"
            if redGreenColorBlind == num {
                conditionLabel.text = "Red Green Colorblind"
            } else if redColorBlind == num {
                conditionLabel.text = "Red Colorblind"
            } else if greenColorBlind == num {
                conditionLabel.text = "Green Colorblind"
            } else if totalColorBlind == num {
                conditionLabel.text = "Total Colorblind"
            } else {
                conditionLabel.text = ""
            }
        }
    }
    
    @IBAction func firstPress(_ sender: UIButton) {
        colorChoice(1)
    }
    
    @IBAction func secondPress(_ sender: UIButton) {
        colorChoice(2)
    }
    
    @IBAction func thirdPress(_ sender: UIButton) {
        colorChoice(3)
    }
    
    @IBAction func fourthPress(_ sender: UIButton) {
        colorChoice(4)
    }
    
    @IBAction func nextTest(_ sender: UIButton) {
        plateNumber = Int(arc4random_uniform(7))
        setPlate()
        correctLabel.text = ""
        conditionLabel.text = ""
    }
    
}
