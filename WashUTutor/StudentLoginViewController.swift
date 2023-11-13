//
//  StudentLoginViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 10/27/23.
//

import UIKit

class StudentLoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func forgetPassword(_ sender: Any){
    }
    
    @IBAction func loginButton(_ sender: Any)
    {
        if userEmailTextBox.text!.isEmpty || passwordTextBox.text!.isEmpty{
        }
        else {
            if userEmailTextBox.text!.contains("wustl.edu"){
                print("This is a WashU email")
                studentLoginSign(email: userEmailTextBox.text!, password: passwordTextBox.text!)
                //getStudentData()
                //createAppointment(appointmentID: "3", date: "11/14/2023", startTime: "11:00 am", endTime: "12:00", location: "Crow Hall", subject: "CS131", caption: "I need help on python.")
                //createAppointment(appointmentID: "4", date: "11/20/2023", startTime: "11:00 am", endTime: "12:00", location: "Seigle Hall", subject: "CS412", caption: "I need help on python.")
                //getStudentAppointments()
                //getAllAvailiableAppointments()
                //deleteStudentAppointments(appointmentID: "2")
            }
            
            else{
                let alert = UIAlertController(title: "Error", message: "The email is not WashU email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
