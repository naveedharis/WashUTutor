

import UIKit

class StudentManageAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var bookedAppointmentTable: UITableView!
    
    var selectedWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    var bookedAppointmentData: [Any] = []
    var filteredAppointments: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bookedAppointmentTable.dataSource = self
        bookedAppointmentTable.delegate = self
        setWeekView()
        fetchAndFilterAppointments()
    }
    
    func setWeekView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedWeekStart)!
        weekLabel.text = "\(dateFormatter.string(from: selectedWeekStart)) - \(dateFormatter.string(from: endOfWeek))"
    }

    func fetchAndFilterAppointments() {
        getStudentAppointments { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookedAppointments):
                    print("Fetched Appointments: \(bookedAppointments)")
                    self?.bookedAppointmentData = bookedAppointments
                    self?.filterAppointmentsForSelectedWeek()
                case .failure(let error):
                    print("Error fetching student appointments:", error)
                }
            }
        }
    }

    func filterAppointmentsForSelectedWeek() {
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedWeekStart)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

//        print("Selected Week Start: \(dateFormatter.string(from: selectedWeekStart))")
//        print("End of Week: \(dateFormatter.string(from: endOfWeek))")

        filteredAppointments = bookedAppointmentData.filter { appointment in
            guard let appointmentDict = appointment as? [String: Any],
                  let appointmentDateString = appointmentDict["date"] as? String,
                  let appointmentDate = dateFormatter.date(from: appointmentDateString) else {
                print("Failed to parse date string: \(String(describing: appointment))")
                return false
            }
            let isWithinWeek = appointmentDate >= selectedWeekStart && appointmentDate <= endOfWeek
            print("Checking appointment on \(appointmentDateString): \(isWithinWeek)")
            return isWithinWeek
        }
//        print("Filtered Appointments for Selected Week: \(filteredAppointments)")
        bookedAppointmentTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAppointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BookedAppointmentCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier),
              let appointment = filteredAppointments[indexPath.row] as? [String: Any] else {
            return UITableViewCell()
        }
        

        if let subject = appointment["subject"] as? String,
            let date = appointment["date"] as? String,
            let startTime = appointment["startTime"] as? String,
            let endTime = appointment["endTime"] as? String,
            let location = appointment["location"] as? String {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "\(subject), \(date), \n\(startTime) - \(endTime), \(location)"
        } else {
            cell.textLabel?.text = "Unknown"
        }
        return cell
    }


    @IBAction func previousWeek(_ sender: Any) {
        selectedWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: selectedWeekStart)!
        setWeekView()
        filterAppointmentsForSelectedWeek()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: selectedWeekStart)!
        setWeekView()
        filterAppointmentsForSelectedWeek()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// Get the start of the week
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
}
