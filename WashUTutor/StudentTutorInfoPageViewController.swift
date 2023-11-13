//
//  StudentTutorInfoPageViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/12/23.
//

import UIKit
import Cosmos

class StudentTutorInfoPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var tutorClassTableView: UITableView!
    @IBOutlet weak var tutorYear: UILabel!
    
    @IBOutlet weak var fiveStarRating: CosmosView!
    @IBOutlet weak var reviewTextBox: UITextView!
    
    var tutorNameString: String?
    var tutorYearString: String?
    var tutorClasses: [String]?
    var tutorEmail: String?
    var tutorIDString: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorClassTableView.dataSource = self
        tutorClassTableView.delegate = self
        tutorName.text = tutorNameString
        tutorYear.text = tutorYearString
        fiveStarRating.rating=5
        fiveStarRating.didFinishTouchingCosmos = { rating in}
        fiveStarRating.didTouchCosmos = {rating in}
        
        self.tutorClassTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorClasses?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tutorClasses?[indexPath.row]
        return cell
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
