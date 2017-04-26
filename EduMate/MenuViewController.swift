//
//  MenuViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct Subject{
    let Name : String!
    let ID : String!
    let TimeStart : String!
    let TimeEnd : String!
    let Location : String!
}

class SubjectTableViewCell: UITableViewCell {
    @IBOutlet weak var Label_Title: UILabel!
    @IBOutlet weak var Label_StartTime: UILabel!
    @IBOutlet weak var Label_Location: UILabel!
    @IBOutlet weak var Label_WeeklyRepeat: UILabel!
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseRef : FIRDatabaseReference!
    
    var posts = [Subject]()
    
    var Name_Array : [String] = [String]()
    var ID_Array : [String] = [String]()
    var StartTime_Array : [String] = [String]()
    var EndTime_Array : [String] = [String]()
    var WeeklyRepeat_Array : [String] = [String]()
    var Location_Array : [String] = [String]()
    
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var SegmentControl_Subjects: UISegmentedControl!
    
    var ValueToPass_ID:String!
    
    var SelectedDaySymbols = ""
    
    //Outlet Area
    @IBOutlet weak var Label_CurrentTime: UILabel!
    @IBOutlet weak var Label_CurrentDate: UILabel!
    
    
    
    @IBAction func Button_Refresh(_ sender: Any) {
        switch SegmentControl_Subjects.selectedSegmentIndex{
        case 0:
            Subjects_Load_Today()
        case 1:
            Subjects_Load_All()
        default:
            break
        }
    }
    
    @IBAction func Button_AddNew(_ sender: Any) {
        performSegue(withIdentifier: "Subject_AddNew", sender: self)
    }
    
    @IBAction func Button_NextDate(_ sender: Any) {
        
    }
    @IBAction func Button_PreviousDate(_ sender: Any) {
        
    }
    @IBAction func SegmentControl_Change(_ sender: Any) {
        switch SegmentControl_Subjects.selectedSegmentIndex{
        case 0:
                Subjects_Load_Today()
        case 1:
                Subjects_Load_All()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        //Set navigation Bar transparent
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        //Real Time Update
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MenuViewController.updateLabel), userInfo: nil, repeats:true)
        
        //print("0. \(Name_Array[0])")
        //print("1. \(Name_Array[1])")
        
        switch SegmentControl_Subjects.selectedSegmentIndex{
        case 0:
            Subjects_Load_Today()
        case 1:
            Subjects_Load_All()
        default:
            break
        }
        
        //Table Refreshing
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Subject_Refresh), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        MenuTableView.refreshControl = refreshControl
        
    }
    
    func Subjects_Load_Today()
    {
        self.Name_Array.removeAll()
        self.ID_Array.removeAll()
        self.StartTime_Array.removeAll()
        self.EndTime_Array.removeAll()
        self.Location_Array.removeAll()
        self.WeeklyRepeat_Array.removeAll()
        //print("[MENU] Items Array Cleared. Ready For Download.")
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "Name").observe(.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as! NSDictionary
            
            let Name_DL = snapshotValue["Name"] as? String
            self.Name_Array.append(Name_DL!)
            
            let ID_DL = snapshotValue["ID"] as? String
            self.ID_Array.append(ID_DL!)
            
            let StartTime_DL = snapshotValue["TimeStart"] as? String
            self.StartTime_Array.append(StartTime_DL!)
            
            let EndTime_DL = snapshotValue["TimeEnd"] as? String
            self.EndTime_Array.append(EndTime_DL!)
            
            let WeeklyRepeat_DL = snapshotValue["WeeklyRepeat"] as? String
            self.WeeklyRepeat_Array.append(WeeklyRepeat_DL!)
            
            let Location_DL = snapshotValue["Location"] as? String
            self.Location_Array.append(Location_DL!)
       
            self.MenuTableView.reloadData()
            
            //dump(self.Name_Array)
            
            
        })
        print("[MENU] Items [Today] Download Complete.")
    }
    
    func Subjects_Load_All()
    {
        self.Name_Array.removeAll()
        self.ID_Array.removeAll()
        self.StartTime_Array.removeAll()
        self.EndTime_Array.removeAll()
        self.Location_Array.removeAll()
        //print("[MENU] Items Array Cleared. Ready For Download.")
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "TimeStart").observe(.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as! NSDictionary
            
            let Name_DL = snapshotValue["Name"] as? String
            self.Name_Array.append(Name_DL!)
            
            let ID_DL = snapshotValue["ID"] as? String
            self.ID_Array.append(ID_DL!)
            
            let StartTime_DL = snapshotValue["TimeStart"] as? String
            self.StartTime_Array.append(StartTime_DL!)
            
            let EndTime_DL = snapshotValue["TimeEnd"] as? String
            self.EndTime_Array.append(EndTime_DL!)
            
            let WeeklyRepeat_DL = snapshotValue["WeeklyRepeat"] as? String
            self.WeeklyRepeat_Array.append(WeeklyRepeat_DL!)
            
            let Location_DL = snapshotValue["Location"] as? String
            self.Location_Array.append(Location_DL!)
            
            self.MenuTableView.reloadData()
            
            //dump(self.Name_Array)
            
            
        })
        print("[MENU] Items [All] Download Complete.")
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
        let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
        
        //Display Date and Time
        Label_CurrentTime.text = "\(hour):\(minutes)"
        Label_CurrentDate.text = "\(day) \(monthName) \(year)"
        SelectedDaySymbols = dayName
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
        return Name_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectTableViewCell
        
        cell.Label_Title?.text = Name_Array[indexPath.row]
        cell.Label_StartTime?.text = StartTime_Array[indexPath.row]
        cell.Label_Location?.text = Location_Array[indexPath.row]
        cell.Label_WeeklyRepeat?.text = WeeklyRepeat_Array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        //let currentCell = tableView.cellForRow(at: indexPath)! as! SubjectTableViewCell
        
        ValueToPass_ID = ID_Array[indexPath.row]
        
        self .performSegue(withIdentifier: "Subject_Selected", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if (segue.identifier == "Subject_Selected"){
            let SubjectViewController = segue.destination as! SubjectViewController
            SubjectViewController.SelectedSubjectID = ValueToPass_ID
        }
        if (segue.identifier == "Subject_AddNew"){
            let EditSubjectViewController = segue.destination as! EditSubjectViewController
            EditSubjectViewController.SelectedSubjectID = "ADDNEW"
        }
    }
    
    func Subject_Refresh(refreshControl: UIRefreshControl) {
        switch SegmentControl_Subjects.selectedSegmentIndex{
        case 0:
            Subjects_Load_Today()
        case 1:
            Subjects_Load_All()
        default:
            break
        }
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
        print("[MENU] Pull Refresh Complete.")
    }
    
}
