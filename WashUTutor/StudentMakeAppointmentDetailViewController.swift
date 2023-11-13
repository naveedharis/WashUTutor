import UIKit

class StudentMakeAppointmentDetailViewController: UIViewController {
    
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

    private func updateUI() {
        print("Received data: \(String(describing: appointmentData))")
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
