//
//  DualDataViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/22/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase

class DualDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal var patternData: PatternData?
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var namePicker: UIPickerView!
    @IBOutlet weak var barChart: BarChartView!
    var patternRef: DatabaseReference?
    var names = [String]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patternRef = Database.database().reference().child("Patterns")
        patternRef?.observeSingleEvent(of: .value, with: {
            snapshot in
            var tempNames = [String]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print("key = \(snap.key)")
                tempNames.append(snap.key)
            }
            self.setNames(tempNames: tempNames)
        })
        barChart.chartDescription?.text = ""
        barChart.xAxis.axisMinimum = -0.5
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.labelPosition = .bottom
        barChart.leftAxis.axisMinimum = -0.0
        barChart.leftAxis.axisMaximum = 15.0
        barChart.legend.enabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.highlighter = nil
        barChart.rightAxis.enabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawLabelsEnabled = true
        barChart.xAxis.wordWrapEnabled = true
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["percent", "total"])
        barChart.xAxis.granularity = 1
        barChart.xAxis.labelCount = 2
        updateGraph()
    }
    
    func updateGraph() {
        if let patternInfo = patternData {
            var stats = [ChartDataEntry]()
            
            let percent = patternInfo.total != 0 ? (patternInfo.success * 100) / patternInfo.total : 0
            percentageLabel.text = "Percentage: \(String(percent))"
            var dataEntry = BarChartDataEntry(x: 0, y: Double(patternInfo.success))
            stats.append(dataEntry)
            
            dataEntry = BarChartDataEntry(x: 1, y: Double(patternInfo.total))
            stats.append(dataEntry)
            
            let chartDataSet = BarChartDataSet(values: stats, label: "Result")
            chartDataSet.colors = ChartColorTemplates.joyful()
            let chartData = BarChartData(dataSet: chartDataSet)
            barChart.data = chartData
            barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        }
    }
    
    func setNames(tempNames: [String]) {
        names = tempNames
        names.sort()
        namePicker.reloadAllComponents()
        namePicker.selectRow(names.index(of: (patternData?.name)!)!, inComponent: 0, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return names.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return names[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let name = names[row]
        patternRef?.queryOrderedByKey().queryEqual(toValue: name).observe(.value, with: {
            snapshot in
            self.patternData = PatternData(key: name, snapshot: snapshot)
            self.updateGraph()
        })
    }
}

