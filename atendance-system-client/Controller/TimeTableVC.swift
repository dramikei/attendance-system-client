//
//  TimeTableVC.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 05/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import UIKit

class TimeTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "TTCell"
    let placeholderName = "Dr. abc xyz"
    let placeholderSub = "EMAT101L"
    let placeholderTime = "8:30 AM"
    let placeholderClass = "A LH 01"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TTCell else { return UITableViewCell() }
        cell.teacherLabel.text = placeholderName
        cell.subjectLabel.text = placeholderSub
        cell.timeLabel.text = placeholderTime
        cell.classLabel.text = placeholderClass
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}
