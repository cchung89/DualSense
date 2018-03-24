//
//  ColorDataViewController.swift
//  FinalProject
//
//  Created by CheckoutUser on 3/7/18.
//  Copyright © 2018 Local Account 436-30. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase

class ColorDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal var colorData: ColorData?
    @IBOutlet weak var namePicker: UIPickerView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var colorStatTable: UITableView!
    let colors = ["red", "orange", "yellow", "green", "blue", "purple"]
    var percentages = [Double]()
    var colorRef: DatabaseReference?
    var names = [String]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorRef = Database.database().reference().child("Colors")
        colorRef?.observeSingleEvent(of: .value, with: {
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
        barChart.leftAxis.axisMaximum = 100.0
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
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: colors)
        barChart.xAxis.granularity = 1
        barChart.xAxis.labelCount = 6
        updateGraph()
    }
    
    func updateGraph() {
        percentages.removeAll()
        if let colorInfo = colorData {
            var percents = [ChartDataEntry]()
            
            var percent = colorInfo.red.total != 0 ? (colorInfo.red.success * 100) / colorInfo.red.total : 0
            var dataEntry = BarChartDataEntry(x: 0, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            percent = colorInfo.orange.total != 0 ? (colorInfo.orange.success * 100) / colorInfo.orange.total : 0
            dataEntry = BarChartDataEntry(x: 1, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            percent = colorInfo.yellow.total != 0 ? (colorInfo.yellow.success * 100) / colorInfo.yellow.total : 0
            dataEntry = BarChartDataEntry(x: 2, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            percent = colorInfo.green.total != 0 ? (colorInfo.green.success * 100) / colorInfo.green.total : 0
            dataEntry = BarChartDataEntry(x: 3, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            percent = colorInfo.blue.total != 0 ? (colorInfo.blue.success * 100) / colorInfo.blue.total : 0
            dataEntry = BarChartDataEntry(x: 4, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            percent = colorInfo.purple.total != 0 ? (colorInfo.purple.success * 100) / colorInfo.purple.total : 0
            dataEntry = BarChartDataEntry(x: 5, y: Double(percent))
            percentages.append(Double(percent))
            percents.append(dataEntry)
            
            let chartDataSet = BarChartDataSet(values: percents, label: "Percentage")
            chartDataSet.colors = [.red, .orange, .yellow, .green, .blue, .purple]
            let chartData = BarChartData(dataSet: chartDataSet)
            barChart.data = chartData
            barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        }
    }
    
    func setNames(tempNames: [String]) {
        names = tempNames
        names.sort()
        namePicker.reloadAllComponents()
        namePicker.selectRow(names.index(of: (colorData?.name)!)!, inComponent: 0, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? DataTVCell
        
        let color = colors[indexPath.row]
        let percent = percentages[indexPath.row]
        cell?.valueLabel?.text = String(color)
        cell?.percentLabel?.text = String(percent)
        
        return cell!
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
        colorRef?.queryOrderedByKey().queryEqual(toValue: name).observe(.value, with: {
            snapshot in
            self.colorData = ColorData(key: name, snapshot: snapshot)
            self.colorStatTable.reloadData()
            self.updateGraph()
        })
    }
}

