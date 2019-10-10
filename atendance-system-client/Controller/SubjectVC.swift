//
//  SubjectVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 10/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit
import Charts


class SubjectVC: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var markAttendanceBtn: UIButton!
    
    
    let placeholderPresent = PieChartDataEntry(value: 30.0)
    let placeholderAbsent = PieChartDataEntry(value: 30.0)
    let isAttendanceOn = true
    
    var totalAttendanceDataEntries = [PieChartDataEntry]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        updateChartData()
        if isAttendanceOn {
            markAttendanceBtn.isHidden = false
        } else {
            markAttendanceBtn.isHidden = true
        }
    }
    
    
    @IBAction func attendanceBtnPressed(_ sender: Any) {
        
        
    }
    
    
    func setupChart() {
        placeholderAbsent.label = "Absent"
        placeholderPresent.label = "Present"
        totalAttendanceDataEntries = [placeholderAbsent, placeholderPresent]
    }
    
    func updateChartData() {
        let chartDataset = PieChartDataSet(entries: totalAttendanceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataset)
        let colors = [UIColor(red:0.91, green:0.33, blue:0.22, alpha:1.0), UIColor(red:0.20, green:0.92, blue:0.75, alpha:1.0)]
        chartDataset.colors = colors
        pieChart.data = chartData
    }
    


}
