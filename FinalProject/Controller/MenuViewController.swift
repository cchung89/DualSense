//
//  MenuViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/6/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    internal var name: String?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome: " + name!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "frequency" {
            let destVC = segue.destination as! SoundViewController
            destVC.name = name
        } else if segue.identifier == "dual" {
            let destVC = segue.destination as! DualViewController
            destVC.name = name
        } else if segue.identifier == "color" {
            let destVC = segue.destination as! ColorViewController
            destVC.name = name
        }
    }
    
    @IBAction func unwindPattern(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindSoundTest(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindColorTest(segue: UIStoryboardSegue) {
        
    }
}
