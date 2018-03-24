//
//  CTutorialViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/22/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit

class CTutorialViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var colorBlindPicker: UIPickerView!
    @IBOutlet weak var hexCodeField: UITextField!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var colorBlindLabel: UILabel!
    
    let visionTypes = ["normal", "protanomaly", "protanopia", "deuteranomaly", "deuteranopia", "tritanomaly", "tritanopia", "achromatomaly", "achromatopsia"]
    let wikiUrl = URL(string: "http://en.wikipedia.org/wiki/Color_blindness")
    let simUrl = URL(string: "http://www.color-blindness.com/coblis2/index.html")
    
    var colorblind: ColorBlindGenerator!
    var currentType = "normal"
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorblind = ColorBlindGenerator()
        hexCodeField.text = "ff0000ff"
        normalLabel.backgroundColor = .red
        colorBlindLabel.backgroundColor = colorblind.colorConvert(color: .red, type: currentType)
        colorBlindPicker.reloadAllComponents()
        colorBlindPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goWiki(sender: AnyObject) {
        UIApplication.shared.open(wikiUrl!, options: [:], completionHandler: nil)
    }
    
    @IBAction func goColorSim(sender: AnyObject) {
        UIApplication.shared.open(simUrl!, options: [:], completionHandler: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let newsAlert = UIAlertController(title: "Color Hex Code Error", message: "Only 8 Hex Code Values are allowed", preferredStyle: .alert)
        newsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("OK pressed")
        }))
        if let hex = hexCodeField.text {
            if hex.count == 8 {
                let matched = matches(for: ".*[^0-9A-Fa-f].*", in: hex)
                if matched.count == 0 {
                    normalLabel.backgroundColor = UIColor(hexRGBA: hex)
                    colorBlindLabel.backgroundColor = colorblind.colorConvert(color: UIColor(hexRGBA: hex)!, type: currentType)
                    return true
                }
            }
        }
        present(newsAlert, animated: true, completion: nil)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return visionTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return visionTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = visionTypes[row]
        currentType = type
        colorBlindLabel.backgroundColor = colorblind.colorConvert(color: normalLabel.backgroundColor!, type: type)
    }
}
