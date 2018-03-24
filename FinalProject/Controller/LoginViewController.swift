//
//  LoginViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/6/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if segueCheck() {
            performSegue(withIdentifier: "login", sender: self)
        }
        return true
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func segueCheck() ->Bool {
        let newsAlert = UIAlertController(title: "Login Error", message: "Only Whitespace and alphabets are allowed!", preferredStyle: .alert)
        newsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("OK pressed")
        }))
        if let name = nameTF.text {
            if name != "" {
                let matched = matches(for: ".*[^A-Za-z ].*", in: name)
                if matched.count == 0 {
                    return true
                }
            }
        }
        present(newsAlert, animated: true, completion: nil)
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        return segueCheck()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            let destVC = segue.destination as! MenuViewController
            destVC.name = nameTF.text!
        }
    }
}
