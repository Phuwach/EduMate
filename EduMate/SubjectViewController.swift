//
//  SubjectViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var Label_Title: UILabel!
    @IBOutlet weak var Label_Detail: UILabel!
}

class EditDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var Label_Title: UILabel!
    @IBOutlet weak var TextField_Detail: UITextField!
}

class SubjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var DetailTableView: UITableView!
    @IBOutlet weak var EditDetailTableView: UITableView!
    
    @IBOutlet weak var DetailNavBar: UINavigationBar!
    @IBOutlet weak var EditDetailNavBar: UINavigationBar!
    
    @IBOutlet weak var Label_Head_SubjectName: UILabel!
    @IBOutlet weak var Label_Head_SubjectID: UILabel!
    
    var databaseRef : FIRDatabaseReference!
    
    var SelectedSubjectID = ""
    
    var Title_Array = ["Subject Name",
                      "Subject ID",
                      "Begin at",
                      "End at",
                      "Repeat Every",
                      "Location",]
    
    var Detail_Array : [String] = [String]()
    
    var cell_Detail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set navigation Bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        print("[SUBJECT] Subject ID: \(SelectedSubjectID)")
        IndividualSubject_Load()
        print("[SUBJECT] Download Complete.")
        
        let when = DispatchTime.now() + 1 // change ... to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.IndividualSubject_Load()
            print("[SUBJECT] 1 Second Auto Refresh Complete.")
        }
    
        //Table Refreshing
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Subject_Refresh), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        DetailTableView.refreshControl = refreshControl
        
    }

    func IndividualSubject_Load(){
        self.Detail_Array.removeAll()
        //print("[SUBJECT] Array Cleared. Ready For Download.")
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "ID").queryEqual(toValue: SelectedSubjectID).observe(.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as! NSDictionary
            
            let Name_DL = snapshotValue["Name"] as? String
            self.Detail_Array.append(Name_DL!)
            
            let ID_DL = snapshotValue["ID"] as? String
            self.Detail_Array.append(ID_DL!)
            
            let StartTime_DL = snapshotValue["TimeStart"] as? String
            self.Detail_Array.append(StartTime_DL!)
            
            let EndTime_DL = snapshotValue["TimeEnd"] as? String
            self.Detail_Array.append(EndTime_DL!)
            
            let WeeklyRepeat_DL = snapshotValue["WeeklyRepeat"] as? String
            self.Detail_Array.append(WeeklyRepeat_DL!)
            
            let Location_DL = snapshotValue["Location"] as? String
            self.Detail_Array.append(Location_DL!)
            
            self.DetailTableView.reloadData()
            //dump(self.Detail_Array)
            
            self.Label_Head_SubjectName.text = Name_DL?.uppercased()
            self.Label_Head_SubjectID.text = ID_DL?.uppercased()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Edit(_ sender: Any) {
        self .performSegue(withIdentifier: "Subject_Edit", sender: self)
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
        return self.Title_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == DetailTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            cell.Label_Title?.text = Title_Array[indexPath.row]
            cell.Label_Detail?.text = Detail_Array[indexPath.row]
            return cell
        }
        else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "EditDetailCell", for: indexPath) as! EditDetailTableViewCell
            cell2.Label_Title?.text = Title_Array[indexPath.row]
            cell2.TextField_Detail?.text = Detail_Array[indexPath.row]
            
            return cell2
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if (segue.identifier == "Subject_Edit"){
            let EditSubjectViewController = segue.destination as! EditSubjectViewController
            EditSubjectViewController.SelectedSubjectID = SelectedSubjectID
        }
    }
    
    func Subject_Refresh(refreshControl: UIRefreshControl) {
        IndividualSubject_Load()
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
        print("[SUBJECT] Pull Refresh Complete.")
    }
    
}
