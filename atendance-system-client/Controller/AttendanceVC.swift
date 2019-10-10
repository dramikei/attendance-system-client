//
//  AttendanceVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 05/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit

class AttendanceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "attendanceIdentifier"
    let placeholderName = "EMAT101L"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AttendanceCell else { return UITableViewCell() }
        cell.subjectName.text = placeholderName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}
