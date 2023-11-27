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
        startTimeFormatter.timeStyle = .short
        endTimeFormatter.timeStyle = .short
       
    }
    
    
    @IBOutlet weak var TutorDate: UIDatePicker!
    
    @IBOutlet weak var Repeat: UISwitch!
    
    
    @IBOutlet weak var TutorStartTime: UIDatePicker!
    
    
    @IBOutlet weak var TutorEndTime: UIDatePicker!
    
    
    @IBOutlet weak var TutorLocation: UITextField!
    
    
    @IBOutlet weak var tutorAnnouncement: UITextField!
    
    @IBAction func tutorAddApp(_ sender: Any) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startTimeFormatter.dateFormat = "hh:mm a"
        endTimeFormatter.dateFormat = "hh:mm a"
        
        let dateString = dateFormatter.string(from: TutorDate.date)
        let currentDate = dateFormatter.string(from: Date.now)
        
        let startTimeString = startTimeFormatter.string(from: TutorStartTime.date)
        
        let endTimeString = endTimeFormatter.string(from: TutorEndTime.date)
        
        print(dateString)
        print(startTimeString)
        print(endTimeString)
    
        if TutorDate.date > Date.now || TutorDate.date == Date.now {
            print("TutorDate is after the current date")
            let difference = TutorEndTime.date.timeIntervalSince(TutorStartTime.date)/3600
            if difference <= 1 && difference > 0 {
                print("1 hour or less")
                tutorAddAppointment(tutorUserID: tutorID, date: dateString, startTime: startTimeString, announcement: tutorAnnouncement.text ?? "", endTime: endTimeString, location: TutorLocation.text ?? "", subject: "CSE 438")
                presentAlert(title: "Appointment Added", message: "Appointment has been created")
            }
            else{
                print("More than one hour")
                presentAlert(title: "Timing is incorrect", message: "Please input the correct time intervals. Must be a hour long or less.")
            }
        }
        else {
            print("TutorDate is before the current date")
            presentAlert(title: "Need correct day", message: "Please the date of the current day or after it.")
        }
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
