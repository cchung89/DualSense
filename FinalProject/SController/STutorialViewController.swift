//
//  STutorialViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/22/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import AVFoundation

class STutorialViewController: UIViewController {
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var engine: AVAudioEngine!
    var tone: TonePlayerUnit!
    let url = URL(string: "http://www.nationalhearingtest.org/wordpress/?p=786")
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tone = TonePlayerUnit()
        tone.volume = 0.5
        frequencyLabel.text = String(format: "%.1f", tone.frequency)
        intensityLabel.text = String(format: "%.1f", tone.volume)
        frequencySlider.minimumValue = -6.0
        frequencySlider.maximumValue = 6.0
        frequencySlider.value = 0.0
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tone.stop()
        engine.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func searchInfo(sender: AnyObject) {
        engine.mainMixerNode.volume = 0.0
        tone.stop()
        engine.stop()
        playButton.setTitle("Play", for: UIControlState())
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func frequencySliderChanged(_ sender: UISlider) {
        let freq = 440.0 * pow(2.0, Double(frequencySlider.value))
        tone.frequency = freq
        frequencyLabel.text = String(format: "%.1f", freq)
    }
    
    @IBAction func intensitySliderChanged(_ sender: UISlider) {
        let intensity = intensitySlider.value
        tone.volume = intensity
        intensityLabel.text = String(format: "%.1f", intensity)
    }
    
    @IBAction func togglePlay(_ sender: UIButton) {
        if tone.isPlaying {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            engine.stop()
            sender.setTitle("Play", for: UIControlState())
        } else {
            do {
                try engine.start()
            } catch let error as NSError {
                print(error)
            }
            tone.volume = 0.5
            tone.preparePlaying()
            tone.play()
            engine.mainMixerNode.volume = 0.5
            sender.setTitle("Stop", for: UIControlState())
        }
    }
}
