//
//  TutorViewAppointViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/12/23.
//

import UIKit

class TutorViewAppointViewController: UIViewController {

    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var student: UILabel!
    @IBOutlet weak var questions: UITextView!
    
    var courseNumberString: String?
    var dateString: String?
    var locationString: String?
    var startTimeString: String?
    var endTimeString: String?
    var studentString: String?
    var questionsString: String?
    var appointmentID: String?
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        courseNumber.text = courseNumberString
        date.text = dateString
        time.text = (startTimeString ?? "") + "-" + (endTimeString ?? "")
        location.text = locationString
        questions.text = questionsString
        print("Student\(studentString ?? "")")
        student.text = studentString
        

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelAppointment(_ sender: Any) {
        deleteStudentAppointments(appointmentID: appointmentID ?? "")
        presentAlert(title: "Appointment canceled", message: "Appointment has been canceled.")
    }
    private func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
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
