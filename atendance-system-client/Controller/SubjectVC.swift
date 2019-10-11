//
//  SubjectVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 10/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit
import Charts
import LocalAuthentication
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class SubjectVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var markAttendanceBtn: UIButton!
    
    
    
    let placeholderPresent = PieChartDataEntry(value: 30.0)
    let placeholderAbsent = PieChartDataEntry(value: 30.0)
    let isAttendanceOn = true
    
    var totalAttendanceDataEntries = [PieChartDataEntry]()
    var context = LAContext()
    let locationManager = CLLocationManager()
    let requiredSSID = "STUD"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = CLLocationManager.authorizationStatus()
        if status != .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        setupChart()
        updateChartData()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if isAttendanceOn {
            markAttendanceBtn.isHidden = false
        } else {
            markAttendanceBtn.isHidden = true
        }
    }
    
    
    @IBAction func attendanceBtnPressed(_ sender: Any) {
        context = LAContext()
        context.localizedCancelTitle = "Enter secret code"
        // First check if we have the needed hardware support.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in
                if success {
                    print(self.getBSSID())
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                        //Authenticated TODO: Check Wifi and Mark Attendance
                        
                    }

                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    print("Not enrolled/Cancelled")
                    // Fall back to a asking for username and password.
                    // If biometrics is not enrolled
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            print("Hi")
            // Fall back to a asking for username and password.
        }
        
    }
    func getBSSID() -> String? {
        var bssid: String!
        let interfaceName = "en0"
        if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
            let currentSSID = dict[kCNNetworkInfoKeySSID as String] as! String
            if currentSSID == requiredSSID {
                bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
            }
        }
        return bssid
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
