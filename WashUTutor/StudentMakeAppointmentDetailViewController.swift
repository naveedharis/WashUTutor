import UIKit

class StudentMakeAppointmentDetailViewController: UIViewController {
    
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet var appointmentDate: UILabel!
    @IBOutlet var appointmentTime: UILabel!
    @IBOutlet var appointmentTutorID: UILabel!
    @IBOutlet var appointmentLocation: UILabel!
    @IBOutlet var appointmentAnnouncement: UITextField!
    @IBOutlet var tipsLabel: UILabel!
    
    var appointmentData: [String: Any]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    @IBAction func confirmAppointment(_ sender: Any) {
        
        if let appointment = appointmentData {
            let appointmentID = appointment["appointmentID"] as? String ?? "DefaultID"
            let date = appointment["date"] as? String ?? "Unknown Date"
            let startTime = appointment["startTime"] as? String ?? "Unknown Start Time"
            let endTime = appointment["endTime"] as? String ?? "Unknown End Time"
            let location = appointment["location"] as? String ?? "Unknown Location"
            let subject = appointment["subject"] as? String ?? "Unknown Subject"


            createAppointment(appointmentID: appointmentID,
                              date: date,
                              startTime: startTime,
                              endTime: endTime,
                              location: location,
                              subject: subject,
                              caption: tipsLabel.text ?? "No tips")
            
            presentAlert(title: "Appointment created", message: "Appointment has been created.")
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateUI() {
        //print("Received data: \(String(describing: appointmentData))")
        if let appointment = appointmentData {
            appointmentTime.text = "\(appointment["startTime"] as? String ?? "") - \(appointment["endTime"] as? String ?? "")"
            appointmentTutorID.text = appointment["tutorID"] as? String
            appointmentLocation.text = appointment["Location"] as? String
            appointmentAnnouncement.text = appointment["annoucement"] as? String
            tipsLabel.text = "What would you like to work on? Please be specific, so your tutor can prepare! \nEx: Which section of the textbook or what topics?"
            
            // Format and display the date
            if let dateString = appointment["Date"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                
                if let date = dateFormatter.date(from: dateString) {
                    dateFormatter.dateFormat = "EEE MMM d, yyyy"
                    appointmentDate.text = dateFormatter.string(from: date)
                }
            }
        }
    }
    
}
