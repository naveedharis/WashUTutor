
import UIKit

class StudentMakeAppointmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    
    var currentWeek = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCellsView()
        setWeekView()
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
            if CalendarFunc().monthString(date: day) == CalendarFunc().monthString(date: selectedDate) {
                totalSquares.append(CalendarFunc().dayString(date: day))
            } else {
                totalSquares.append("")
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let startOfWeekString = dateFormatter.string(from: startOfWeek)
        dateFormatter.dateFormat = "d"
        let endOfWeekString = dateFormatter.string(from: endOfWeek)
        
        weekLabel.text = "\(startOfWeekString)-\(endOfWeekString)"
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
