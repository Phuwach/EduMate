//
//  LoginViewController.swift
//  EduMate
//
//  Created by Phuwadech Santhanapirom on 3/27/17.
//  Copyright © 2017 Phuwach. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var TextField_Username: UITextField!
    @IBOutlet weak var TextField_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Button_Login(_ sender: Any) {
        if((TextField_Username.text == "") && (TextField_Password.text != "")){
            createAlert(titleText: "Log in failed", messageText: "Please enter USERNAME.")
        }
        if((TextField_Username.text != "") && (TextField_Password.text == "")){
            createAlert(titleText: "Log in failed", messageText: "Please enter PASSWORD.")
        }
        if((TextField_Username.text == "") && (TextField_Password.text == "")){
            createAlert(titleText: "Log in failed", messageText: "Please enter USERNAME and PASSWORD.")
        }
        else{
            createAlert(titleText: "Log in failed", messageText: "Incorrect PASSWORD.")
        }
    }
    
    @IBAction func Button_GuestLogin(_ sender: Any) {
        performSegue(withIdentifier: "Segue_LoginToMenu", sender: self)
    }
    
    func createAlert(titleText : String, messageText : String){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

