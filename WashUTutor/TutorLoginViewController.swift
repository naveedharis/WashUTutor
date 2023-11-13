//
//  TutorLoginViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/8/23.
//

import UIKit

class TutorLoginViewController: UIViewController {

    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
    }
    
    @IBAction func tutorLoginButton(_ sender: Any) {
        if emailTextBox.text!.isEmpty || passwordTextBox.text!.isEmpty{
        }
        else {
            if emailTextBox.text!.contains("wustl.edu"){
                print("This is a WashU email")
               // getTutorData(email: emailTextBox.text!, code: passwordTextBox.text!)
                getAllTutorAppointments(tutorID: passwordTextBox.text!) { (appointments, error) in
                    if let error = error {
                        print("Error fetching appointments: \(error)")
                    } else if let appointments = appointments {
                        // Process the fetched appointments
                        for appointment in appointments {
                            print(appointment)
                        }
                    }
                }
                
            }

            else{
                let alert = UIAlertController(title: "Error", message: "The email is not WashU email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
