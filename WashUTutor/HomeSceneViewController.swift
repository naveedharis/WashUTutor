//
//  HomeSceneViewController.swift
//  WashUTutor
//
//  Created by Wilson Wang on 11/12/23.
//

import UIKit

class HomeSceneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //start
    //var myArray = ["Wilson", "Wang"]
    var myArray: [TutorAppointment] = []
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        myCell.textLabel?.text = myArray[indexPath.row].classNumber + "," + myArray[indexPath.row].startTime + "," + myArray[indexPath.row].endTime
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TutorAppointVC = storyboard!.instantiateViewController(withIdentifier: "tutorAppoint") as! TutorViewAppointViewController
        
        TutorAppointVC.courseNumberString = myArray[indexPath.row].classNumber
        TutorAppointVC.dateString = myArray[indexPath.row].Date
        TutorAppointVC.locationString = myArray[indexPath.row].Location
        TutorAppointVC.questionsString = myArray[indexPath.row].annoucement
        TutorAppointVC.startTimeString = myArray[indexPath.row].startTime
        TutorAppointVC.endTimeString = myArray[indexPath.row].endTime
        
        if myArray[indexPath.row].status == "Booked" {
            print("student")
        }
        else{
            TutorAppointVC.studentString = "Not booked by student."
        }
        
        navigationController?.pushViewController(TutorAppointVC, animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getAllTutorAppointments(tutorID: "Tutor1") { (appointments, error) in
            if let error = error {
                print("Error fetching appointments: \(error)")
            } else if let appointments = appointments {
                // Process the fetched appointments
                for appointment in appointments {
                    DispatchQueue.main.async {
                        self.myArray.append(appointment)
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        self.tableView.reloadData()
    }
    
   
    
    

    
    
    
        
    
}
