//
//  SubjectViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit
import MapKit

class SubjectViewController: UIViewController, MKMapViewDelegate {

    var receivedData = ""
    @IBOutlet weak var TextField_SubjectName: UITextField!
    @IBOutlet weak var TextField_SubjectID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set navigation Bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        TextField_SubjectName.text = "Name of " + String(receivedData)
        TextField_SubjectID.text = "ID of " + String(receivedData)
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

}
