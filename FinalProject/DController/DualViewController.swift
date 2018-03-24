//
//  DualViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/6/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase

struct Pattern {
    var freq: Int
    var color: UIColor
    
    init(freq: Int, color: UIColor) {
        self.freq = freq
        self.color = color
    }
}

class DualViewController: UIViewController {
    
    internal var name: String?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var colorView: UIImageView!
    
    let tones = [440, 460, 480, 500, 520, 540]
    let colors : [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    var orders =  [Int]()
    var patterns = [Pattern]()
    var seconds = 2
    var timer = Timer()
    var isTimeRunning = false
    var gameStart = false
    var startTimer = 3
    var engine: AVAudioEngine!
    var tone: TonePlayerUnit!
    var donePlaying = true
    var patternData: PatternData?
    var patternRef: DatabaseReference?
    var setupTime = 6
    var currentColor: UIColor = .white
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patternData = PatternData(name: name!)
        patternRef = Database.database().reference().child("Patterns")
        tone = TonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? 0.0)
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        tone.preparePlaying()
        timeLabel.text = ""
        startButton.setTitle("Waiting...", for: .normal)
        colorView.image = UIImage(named: "White.png")
        var colorIndex : Int
        for index in 0...5 {
            colorIndex = Int(arc4random_uniform(6))
            patterns.append(Pattern(freq: tones[index], color: colors[colorIndex]))
        }
        initTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        tone.stop()
        engine.stop()
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(DualViewController.updateInitTimer)), userInfo: nil, repeats: true)
        isTimeRunning = true
    }
    
    func getNextColor(color: UIColor) {
        switch color {
        case .red:
            colorView.image = UIImage(named: "Red.png")
        case .yellow:
            colorView.image = UIImage(named: "Yellow.png")
        case .blue:
            colorView.image = UIImage(named: "Blue.png")
        case .orange:
            colorView.image = UIImage(named: "Orange.png")
        case .green:
            colorView.image = UIImage(named: "Green.png")
        case .purple:
            colorView.image = UIImage(named: "Purple.png")
        default: // For error check
            colorView.image = UIImage(named: "White.png")
        }
    }
    
    @objc func updateInitTimer() {
        if setupTime < 1 {
            timer.invalidate()
            tone.stop()
            engine.stop()
            colorView.image = UIImage(named: "White.png")
            isTimeRunning = false
            startButton.setTitle("Start", for: .normal)
            setupTime = 6
        } else {
            tone.frequency = Double(patterns[6-setupTime].freq)
            tone.play()
            getNextColor(color: patterns[6-setupTime].color)
            setupTime -= 1
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(DualViewController.updateStartTimer)), userInfo: nil, repeats: true)
        isTimeRunning = true
    }
    
    @objc func updateStartTimer() {
        if startTimer < 1 {
            timeLabel.text = ""
            gameStart = true
            startButton.setTitle("Stop", for: .normal)
            updateSoundTimer()
        } else {
            startTimer -= 1
            if startTimer == 0 {
                timeLabel.text = "GO!!!"
            } else {
                timeLabel.text = String(startTimer)
            }
        }
    }
    
    func updateSoundTimer() {
        if seconds < 1 {
            engine.mainMixerNode.volume = 0.0
            tone.stop()
            timer.invalidate()
            seconds = 2
            isTimeRunning = false
            donePlaying = true
        } else {
            if donePlaying {
                let soundIndex = Int(arc4random_uniform(6))
                startButton.setTitle("Stop", for: .normal)
                gameStart = true
                let pattern = patterns[soundIndex]
                tone.frequency = Double(pattern.freq)
                currentColor = pattern.color
                engine.mainMixerNode.volume = 1.0
                tone.preparePlaying()
                tone.play()
                donePlaying = false
            }
            seconds -= 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func resetPattern(_ sender: UIButton) {
        if !isTimeRunning && !gameStart {
            do {
                try engine.start()
            } catch let error as NSError {
                print(error)
            }
            patterns.removeAll()
            tone.preparePlaying()
            startButton.setTitle("Waiting...", for: .normal)
            timeLabel.text = ""
            var colorIndex : Int
            for index in 0...5 {
                colorIndex = Int(arc4random_uniform(6))
                patterns.append(Pattern(freq: tones[index], color: colors[colorIndex]))
            }
            initTimer()
        }
    }
    
    @IBAction func togglePlayStop(_ sender: UIButton) {
        if !isTimeRunning {
            if !gameStart {
                do {
                    try engine.start()
                } catch let error as NSError {
                    print(error)
                }
                timeLabel.text = String(startTimer)
                runTimer()
            } else {
                engine.stop()
                gameStart = false
                startButton.setTitle("Start", for: .normal)
                colorView.image = UIImage(named: "White.png")
                startTimer = 3
            }
        }
    }
    
    @IBAction func redPress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .red {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func yellowPress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .yellow {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func bluePress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .blue {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func orangePress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .orange {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func greenPress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .green {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func purplePress(_ sender: UIButton) {
        if gameStart {
            patternData?.total += 1
            if currentColor == .purple {
                patternData?.success += 1
            }
            patternData?.printResult()
            runTimer()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if gameStart || isTimeRunning {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dualResult") {
            startButton.setTitle("Waiting...", for: .normal)
            let destVC = segue.destination as! DualDataViewController
            destVC.patternData = patternData
            storePatternData()
        }
    }
    
    func storePatternData() {
        let name = patternData?.name
        let newPatternRef = patternRef?.child(name!)
        newPatternRef?.setValue(patternData?.toAnyObject())
    }
}
