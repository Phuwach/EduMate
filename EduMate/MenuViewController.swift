//
//  MenuViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    @IBOutlet weak var Label_CellTitle: UILabel!
    @IBOutlet weak var Label_CellTime: UILabel!
    @IBOutlet weak var Label_CellLocation: UILabel!
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cellContent = ["Physics III",
                       "Calculus I",
                       "Software Engineering",
                       "Operating System",
                       "iOS Development",
                       "Computer Graphics",]
    
    var cellContentLocation = ["RB5 - 5301",
                           "RB3 - 3309",
                           "30 Years Building - 502",
                           "30 Years Building - 502",
                           "30 Years Building - 402",
                           "30 Years Building - 501",]
    
    var cellContentTime = ["08:00",
                             "09:30",
                             "11:00",
                             "13:00",
                             "14:30",
                             "16:00",]
    
    var valueToPass:String!
    
    
    //Outlet Area
    @IBOutlet weak var Label_CurrentTime: UILabel!
    @IBOutlet weak var Label_CurrentDate: UILabel!
    
    
    
    @IBAction func Button_NextDate(_ sender: Any) {
        
    }
    @IBAction func Button_PreviousDate(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set navigation Bar transparent
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MenuViewController.updateLabel), userInfo: nil, repeats:true)
    }
    
    func updateLabel() {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let monthName = calendar.monthSymbols[month - 1]
        
        //Display Date and Time
        Label_CurrentTime.text = "\(hour):\(minutes)"
        Label_CurrentDate.text = "\(day) \(monthName) \(year)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectTableViewCell
        cell.Label_CellTitle?.text = cellContent[indexPath.row]
        cell.Label_CellTime?.text = cellContentTime[indexPath.row]
        cell.Label_CellLocation?.text = cellContentLocation[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        self .performSegue(withIdentifier: "Subject_Selected", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if (segue.identifier == "Subject_Selected"){
            let SubjectViewController = segue.destination as! SubjectViewController
            SubjectViewController.receivedData = valueToPass
        }
    }
}
