//
//  SubjectViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit
import MapKit

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
    
    var UserEditting = false
    
    var receivedData_Title = ""
    var receivedData_Location = ""
    var receivedData_StartTime = ""
    var receivedData_EndTime = ""
    var receivedData_ID = ""
    
    var cell_Title = ["Name",
                      "ID",
                      "Time",
                      "Location",]
    
    var cell_Detail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set navigation Bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        cell_Detail.append(receivedData_Title)
        cell_Detail.append(receivedData_ID)
        cell_Detail.append(String(receivedData_StartTime) + " - " + String(receivedData_EndTime))
        cell_Detail.append(receivedData_Location)
        
        //TextField_SubjectName.text = String(receivedData_Title)
        //TextField_SubjectID.text = String(receivedData_ID)
        //TextField_Time.text = String(receivedData_StartTime) + " - " + String(receivedData_EndTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Edit(_ sender: Any) {
        UserEditting = !UserEditting
        self.EditDetailTableView.isHidden = !self.EditDetailTableView.isHidden
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
        return self.cell_Title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == DetailTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            cell.Label_Title?.text = cell_Title[indexPath.row]
            cell.Label_Detail?.text = cell_Detail[indexPath.row]
            return cell
        }
        else{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "EditDetailCell", for: indexPath) as! EditDetailTableViewCell
            cell2.Label_Title?.text = cell_Title[indexPath.row]
            cell2.TextField_Detail?.text = cell_Detail[indexPath.row]
            return cell2
        }
    }
}
