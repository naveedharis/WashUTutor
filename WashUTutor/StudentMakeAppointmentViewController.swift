
import UIKit

class StudentMakeAppointmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    
    @IBOutlet var availableAppointmentTable: UITableView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var appointmentData: Array<Any> = []
    var currentWeek = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        availableAppointmentTable.dataSource = self
        availableAppointmentTable.delegate = self
        setCellsView()
        setWeekView()
        getAllAvailableAppointments { result in
            switch result {
            case .success(let appointments):
                //("Got appointments:", appointments)
                self.appointmentData = appointments
                //print("Length\(self.appointmentData.count)")
            case .failure(let error):
                print("Error fetching appointments:", error)
            }
        }
        self.availableAppointmentTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.availableAppointmentTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count\(self.appointmentData.count)")
        return self.appointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use a reusable cell identifier for better performance.
           let cellIdentifier = "AppointmentCell"
           let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)

           // Assuming 'appointmentData' is an array of dictionaries and each appointment has a "Location" key.
           if let cellAppointment = appointmentData[indexPath.row] as? [String: Any],
              let location = cellAppointment["Location"] as? String {
               // Set the location to the text label of the cell.
               print(location)
               cell.textLabel?.text = location
           } else {
               // Handle the case where the data is not in the expected format or the "Location" key is not found.
               cell.textLabel?.text = "Unknown"
           }
           
           return cell
    }
    
    func setCellsView()
    {
        let width = (weekCollectionView.frame.size.width ) / 10
        let height = (weekCollectionView.frame.size.height ) / 10
        
        let flowLayout = weekCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setWeekView() {
        totalSquares.removeAll()
        
        let startOfWeek = CalendarFunc().startOfWeek(date: selectedDate)
        let endOfWeek = CalendarFunc().plusDays(date: startOfWeek, numberOfDays: 6)
        
        for i in 0..<7 {
            let day = CalendarFunc().plusDays(date: startOfWeek, numberOfDays: i)
            totalSquares.append(CalendarFunc().dayString(date: day))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let startOfWeekString = dateFormatter.string(from: startOfWeek)
        let endOfWeekString = dateFormatter.string(from: endOfWeek)
        
        // Check if start and end of the week are in the same month
        if CalendarFunc().monthString(date: startOfWeek) == CalendarFunc().monthString(date: endOfWeek) {
            weekLabel.text = "\(startOfWeekString)-\(endOfWeekString)"
            print("Same month")
            print(startOfWeekString)
        } else {
            // If not, include the month name for the end of the week
            dateFormatter.dateFormat = "MMMM d"
            let endOfWeekStringWithMonth = dateFormatter.string(from: endOfWeek)
            weekLabel.text = "\(startOfWeekString) - \(endOfWeekStringWithMonth)"
            print("Different month")
            print(startOfWeekString)
        }
        
        weekCollectionView.reloadData()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        
        return cell
    }
    
    @IBAction func previousWeek(_ sender: Any)
    {
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
        if selectedDate < CalendarFunc().firstOfMonth(date: selectedDate) {
            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: CalendarFunc().firstOfMonth(date: selectedDate))!
            selectedDate = CalendarFunc().startOfWeek(date: selectedDate)
        }
        setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: Any)
    {
        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
        if selectedDate >= CalendarFunc().firstOfNextMonth(date: selectedDate) {
            selectedDate = CalendarFunc().firstOfNextMonth(date: selectedDate)
        }
        setWeekView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
}
