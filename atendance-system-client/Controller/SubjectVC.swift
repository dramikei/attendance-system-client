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
import Alamofire

class SubjectVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var markAttendanceBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
  
    var isAttendanceOn = false
    
    var totalAttendanceDataEntries = [PieChartDataEntry]()
    var context = LAContext()
    let locationManager = CLLocationManager()
    let requiredSSID = "STUD"
    var subjectName = ""
    var attendances: [Attendance] = []
    var presentCount = 0
    var absentCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.subjectName
        let status = CLLocationManager.authorizationStatus()
        if status != .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let parameterdata = [
            "enrolment": userEnrolment?.lowercased(),
            "subject": subjectName.lowercased()
        ]
        
        AF.request(getAttendanceURL, method: .post, parameters: parameterdata, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let attendances = try decoder.decode(AttendanceList.self, from: data)
                self.attendances = attendances.attendances
                for attendance in self.attendances {
                    print("IsPresent: \(attendance.isOn)")
                    if attendance.ispresent == "True" || attendance.ispresent == "true" {
                        self.presentCount += 1
                    } else {
                        self.absentCount += 1
                    }
                    if attendance.isOn == "True" || attendance.isOn == "true" {
                        self.isAttendanceOn = true
                    }
                }
                self.setupChart()
                self.updateChartData()
                if self.isAttendanceOn {
                    self.markAttendanceBtn.isHidden = false
                } else {
                    self.markAttendanceBtn.isHidden = true
                }
            } catch let error {
                print(error)
            }
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
                        let parameterData = [
                            "enrolment": userEnrolment?.lowercased(),
                            "macaddress": self.getBSSID(),
                            "subject": self.subjectName.lowercased()
                        ]
                        AF.request(markAttendanceURL, method: .post, parameters: parameterData, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil).responseJSON { response in
                            guard let data = response.data else { return }
                            do {
                                print(response)
                            } catch let error {
                                print(error)
                            }
                        }
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
        
        let absent = PieChartDataEntry(value: Double(absentCount))
        let present = PieChartDataEntry(value: Double(presentCount))
        absent.label = "Absent"
        present.label = "Present"
        totalAttendanceDataEntries = [absent, present]
    }
    
    func updateChartData() {
        let chartDataset = PieChartDataSet(entries: totalAttendanceDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataset)
        let colors = [UIColor(red:0.91, green:0.33, blue:0.22, alpha:1.0), UIColor(red:0.20, green:0.92, blue:0.75, alpha:1.0)]
        chartDataset.colors = colors
        pieChart.data = chartData
    }
}
