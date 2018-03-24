//
//  ViewController.swift
//  FinalProject
//
//  Created by Local Account 436-30 on 2/12/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase

class SoundViewController: UIViewController {

    internal var name: String?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var hearingButton: UIButton!
    @IBOutlet weak var notHearingButton: UIButton!
    var engine: AVAudioEngine!
    var tone: TonePlayerUnit!
    var seconds = 3
    var timer = Timer()
    var isTimeRunning = false
    var gameStart = false
    var startTimer = 3
    var donePlaying = true
    var soundData: SoundData?
    var soundRef: DatabaseReference?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = ""
        hearingButton.isHidden = true
        notHearingButton.isHidden = true
        soundData = SoundData(name: name!)
        soundRef = Database.database().reference().child("Sounds")
        tone = TonePlayerUnit()
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print(format?.sampleRate ?? 0.0)
        engine = AVAudioEngine()
        engine.attach(tone)
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        tone.stop()
        engine.stop()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SoundViewController.updateStartTimer)), userInfo: nil, repeats: true)
        isTimeRunning = true
    }

    @objc func updateStartTimer() {
        if startTimer < 1 {
            timeLabel.text = ""
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
            seconds = 3
            isTimeRunning = false
            donePlaying = true
            hearingButton.isHidden = false
            notHearingButton.isHidden = false
        } else {
            if donePlaying {
                startButton.setTitle("Stop", for: .normal)
                startButton.isHidden = false
                gameStart = true
                playNextTone()
                donePlaying = false
            }
            seconds -= 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playNextTone() {
        seconds = Int(arc4random_uniform(3) + 1)
        var freq = 1000
        let audioValue = Int(arc4random_uniform(6) + 1)
        switch audioValue {
        case 1:
            freq = 250
            soundData?._250.total += 1
        case 2:
            freq = 500
            soundData?._500.total += 1
        case 3:
            freq = 1000
            soundData?._1000.total += 1
        case 4:
            freq = 2000
            soundData?._2000.total += 1
        case 5:
            freq = 4000
            soundData?._4000.total += 1
        case 6:
            freq = 8000
            soundData?._8000.total += 1
        default:
            freq = 1000
            soundData?._1000.total += 1
        }
        print("\(freq)")
        tone.frequency = Double(freq)
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    @IBAction func togglePlayStop(_ sender: UIButton) {
        if !isTimeRunning {
            if !gameStart {
                do {
                    try engine.start()
                } catch let error as NSError {
                    print(error)
                }
                startButton.isHidden = true
                timeLabel.text = String(seconds)
                runTimer()
            } else {
                engine.stop()
                hearingButton.isHidden = true
                notHearingButton.isHidden = true
                gameStart = false
                startButton.setTitle("Start", for: .normal)
                startTimer = 3
            }
        }
    }
    
    @IBAction func hearingCheck(_ sender: UIButton) {
        if !isTimeRunning && gameStart && donePlaying && !hearingButton.isHidden {
            hearingButton.isHidden = true
            notHearingButton.isHidden = true
            let freq = Int(tone.frequency)
            addSuccess(freq: freq)
            soundData?.printResult()
            runTimer()
        }
    }
    
    @IBAction func notHearingCheck(_ sender: UIButton) {
        if !isTimeRunning && gameStart && donePlaying && !hearingButton.isHidden {
            hearingButton.isHidden = true
            notHearingButton.isHidden = true
            soundData?.printResult()
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
        if (segue.identifier == "soundResult") {
            let destVC = segue.destination as! SoundDataViewController
            destVC.soundData = soundData
            storeSoundData()
        }
    }
    
    func storeSoundData() {
        let name = soundData?.name
        let newSoundRef = soundRef?.child(name!)
        newSoundRef?.setValue(soundData?.toAnyObject())
    }
    
    func addSuccess(freq: Int) {
        switch freq {
        case 250:
            soundData?._250.success += 1
        case 500:
            soundData?._500.success += 1
        case 1000:
            soundData?._1000.success += 1
        case 2000:
            soundData?._2000.success += 1
        case 4000:
            soundData?._4000.success += 1
        case 8000:
            soundData?._8000.success += 1
        default:
            soundData?._1000.success += 1
        }
    }
}

