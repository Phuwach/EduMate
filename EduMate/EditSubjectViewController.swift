//
//  EditSubjectViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 4/20/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class EditSubjectViewController: UIViewController {

    @IBOutlet weak var Name_TF: UITextField!
    @IBOutlet weak var ID_TF: UITextField!
    @IBOutlet weak var StartTime_TF: UITextField!
    @IBOutlet weak var EndTime_TF: UITextField!
    @IBOutlet weak var Location_TF: UITextField!
    
    @IBOutlet weak var SW_Mon: UISwitch!
    @IBOutlet weak var SW_Tue: UISwitch!
    @IBOutlet weak var SW_Wed: UISwitch!
    @IBOutlet weak var SW_Thu: UISwitch!
    @IBOutlet weak var SW_Fri: UISwitch!
    @IBOutlet weak var SW_Sat: UISwitch!
    @IBOutlet weak var SW_Sun: UISwitch!
    
    var databaseRef : FIRDatabaseReference!
    var SelectedSubjectID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (SelectedSubjectID != "ADDNEW"){
            IndividualSubject_Load()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Save(_ sender: Any) {
        if(ID_TF.text == SelectedSubjectID){
            //Update Data
            Subject_Update()
            performSegue(withIdentifier: "Return_SubjectView", sender: sender)
        }
        else {
            //add new Data
            Subject_Add()
            performSegue(withIdentifier: "Return_MenuView", sender: sender)
        }
        
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        if (SelectedSubjectID != "ADDNEW"){
            performSegue(withIdentifier: "Return_MenuView", sender: sender)
        }
        else{
            performSegue(withIdentifier: "Return_SubjectView", sender: sender)
        }
    }
    
    @IBAction func Button_Delete(_ sender: Any) {
        Subject_Delete()
        performSegue(withIdentifier: "Return_MenuView", sender: sender)
    }

    func IndividualSubject_Load(){
        
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "ID").queryEqual(toValue: SelectedSubjectID).observe(.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as! NSDictionary
            
            let Name_DL = snapshotValue["Name"] as? String
            self.Name_TF.text = Name_DL
            
            let ID_DL = snapshotValue["ID"] as? String
            self.ID_TF.text = ID_DL
            
            let StartTime_DL = snapshotValue["TimeStart"] as? String
            self.StartTime_TF.text = StartTime_DL
            
            let EndTime_DL = snapshotValue["TimeEnd"] as? String
            self.EndTime_TF.text = EndTime_DL
            
            let Location_DL = snapshotValue["Location"] as? String
            self.Location_TF.text = Location_DL
            
            let WeeklyRepeat_DL = snapshotValue["WeeklyRepeat"] as? String
            if (WeeklyRepeat_DL!.contains("Mon")){ self.SW_Mon.isOn = true }
            if (WeeklyRepeat_DL!.contains("Tue")){ self.SW_Tue.isOn = true }
            if (WeeklyRepeat_DL!.contains("Wed")){ self.SW_Wed.isOn = true }
            if (WeeklyRepeat_DL!.contains("Thu")){ self.SW_Thu.isOn = true }
            if (WeeklyRepeat_DL!.contains("Fri")){ self.SW_Fri.isOn = true }
            if (WeeklyRepeat_DL!.contains("Sat")){ self.SW_Sat.isOn = true }
            if (WeeklyRepeat_DL!.contains("Sun")){ self.SW_Sun.isOn = true }
            
        })
        print("[EDIT] Subject Details Download Complete.")
    }

    func Subject_Update(){
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "ID").queryEqual(toValue: SelectedSubjectID).observe(.childAdded, with: {(snapshot) in
            
            var WeeklyRepeat_ = ""
            var MultipleDay = false
            
            if (self.SW_Mon.isOn) {
                WeeklyRepeat_ += "Mon"
                MultipleDay = true
            }
            
            if (self.SW_Tue.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Tue"
                MultipleDay = true
            }
            
            if (self.SW_Wed.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Wed"
                MultipleDay = true
            }
            
            if (self.SW_Thu.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Thu"
                MultipleDay = true
            }
            
            if (self.SW_Fri.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Fri"
                MultipleDay = true
            }
            
            if (self.SW_Sat.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Sat"
                MultipleDay = true
            }
            
            if (self.SW_Sun.isOn) {
                if(MultipleDay) { WeeklyRepeat_ += ", "}
                WeeklyRepeat_ += "Sun"
                MultipleDay = true
            }
            
            let childname = snapshot.key
            let updateRef = FIRDatabase.database().reference()
            
            updateRef.child("Subjects").child(childname).child("Name").setValue(self.Name_TF.text)
            updateRef.child("Subjects").child(childname).child("ID").setValue(self.ID_TF.text)
            updateRef.child("Subjects").child(childname).child("TimeStart").setValue(self.StartTime_TF.text)
            updateRef.child("Subjects").child(childname).child("TimeEnd").setValue(self.EndTime_TF.text)
            updateRef.child("Subjects").child(childname).child("Location").setValue(self.Location_TF.text)
            updateRef.child("Subjects").child(childname).child("WeeklyRepeat").setValue(WeeklyRepeat_)
            
        })
        print("[EDIT] Subject Details Update Complete.")
    }
    
    func Subject_Delete(){
        databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").queryOrdered(byChild: "ID").queryEqual(toValue: SelectedSubjectID).observe(.childAdded, with: {(snapshot) in
            
            let childname = snapshot.key
            let deleteRef = FIRDatabase.database().reference()
            
            deleteRef.child("Subjects").child(childname).child("Name").removeValue()
            deleteRef.child("Subjects").child(childname).child("ID").removeValue()
            deleteRef.child("Subjects").child(childname).child("TimeStart").removeValue()
            deleteRef.child("Subjects").child(childname).child("TimeEnd").removeValue()
            deleteRef.child("Subjects").child(childname).child("Location").removeValue()
            deleteRef.child("Subjects").child(childname).child("WeeklyRepeat").removeValue()
            
        })
        print("[EDIT] Subject Delete Complete.")
    }
    
    func Subject_Add(){
        
        var WeeklyRepeat_ = ""
        var MultipleDay = false
        
        if (SW_Mon.isOn) {
            WeeklyRepeat_ += "Mon"
            MultipleDay = true
        }
        
        if (SW_Tue.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Tue"
            MultipleDay = true
        }
        
        if (SW_Wed.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Wed"
            MultipleDay = true
        }
        
        if (SW_Thu.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Thu"
            MultipleDay = true
        }
        
        if (SW_Fri.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Fri"
            MultipleDay = true
        }
        
        if (SW_Sat.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Sat"
            MultipleDay = true
        }
        
        if (SW_Sun.isOn) {
            if(MultipleDay) { WeeklyRepeat_ += ", "}
            WeeklyRepeat_ += "Sun"
            MultipleDay = true
        }
        
        let Name_ = Name_TF.text
        let ID_ = ID_TF.text
        let TimeStart_ = StartTime_TF.text
        let TimeEnd_ = EndTime_TF.text
        let Location_ = Location_TF.text
        let post : [String: AnyObject] = ["Name" : Name_ as AnyObject,
                                          "ID" : ID_ as AnyObject,
                                          "TimeStart" : TimeStart_ as AnyObject,
                                          "TimeEnd" : TimeEnd_ as AnyObject,
                                          "Location" : Location_ as AnyObject,
                                          "WeeklyRepeat" : WeeklyRepeat_ as AnyObject]
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Subjects").childByAutoId().setValue(post)
        print("[EDIT] New Subject Upload Complete.")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if (segue.identifier == "Return_SubjectView"){
            let SubjectViewController = segue.destination as! SubjectViewController
            SubjectViewController.SelectedSubjectID = SelectedSubjectID
        }
    }
    
}
