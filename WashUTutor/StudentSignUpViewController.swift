//
//  StudentSignUpViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/6/23.
//

import UIKit


class StudentSignUpViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func studentSignUp(_ sender: Any){
        if nameTextBox.text!.count != 0 {
            if emailTextBox.text!.count != 0 {
                if emailTextBox.text!.contains("wustl.edu")  {
                    if passwordTextBox.text!.count >= 8 {
                        signUp(name: nameTextBox.text!,email: emailTextBox.text!, password: passwordTextBox.text!)
                        
                        print("Sign up")
                    }
                    else{
                        createAlert(title: "Password not long", message: "Password must be 8 characters long")
                    }
                }
                else{
                    createAlert(title: "Not wustl", message: "Email must be a WUSTL email")
                }
            }
            else{
                createAlert(title: "No input", message: "Enter a wustl email")
            }
        }
        else{
            createAlert(title: "No name", message: "Please your name")
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
