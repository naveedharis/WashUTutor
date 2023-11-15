//
//  TutorAddAppointmentViewController.swift
//  WashUTutor
//
//  Created by Wilson Wang on 11/13/23.
//

import UIKit
import SwiftUI

class TutorAddAppointmentViewController: UIViewController {
    
    @AppStorage("tutorID") var tutorID = ""

    let dateFormatter = DateFormatter()
    
    let startTimeFormatter = DateFormatter()
    
    let endTimeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
       
    }
    
    
    @IBOutlet weak var TutorDate: UIDatePicker!
    
    @IBOutlet weak var Repeat: UISwitch!
    
    
    @IBOutlet weak var TutorStartTime: UIDatePicker!
    
    
    @IBOutlet weak var TutorEndTime: UIDatePicker!
    
    
    @IBOutlet weak var TutorLocation: UITextField!
    
    
    @IBOutlet weak var tutorAnnouncement: UITextField!
    
    @IBAction func tutorAddApp(_ sender: Any) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startTimeFormatter.dateFormat = "HH:mm"
        endTimeFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.string(from: TutorDate.date)
        
        let startTimeString = dateFormatter.string(from: TutorStartTime.date)
        
        let endTimeString = dateFormatter.string(from: TutorEndTime.date)
        
        tutorAddAppointment(tutorUserID: tutorID, date: dateString, startTime: startTimeString, announcement: tutorAnnouncement.text ?? "", endTime: endTimeString, location: TutorLocation.text ?? "", subject: "CSE 438")
        
        presentAlert(title: "Appointment Added", message: "Appointment has been created")
    }
    
    private func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
