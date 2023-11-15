//
//  TutorMessagesViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/13/23.
//

import UIKit
import SwiftUI

class TutorMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @AppStorage("tutorID") var tutorID = ""
    @IBOutlet weak var tableView: UITableView!
    var messages:[String] = ["question1", "question2", "question3"]
    var responses:[String] = ["Because1", "Because2", "Because3"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let responseVC = storyboard!.instantiateViewController(withIdentifier: "tutorResponse") as! TutorResponseViewController
        
        responseVC.studentQuestion = messages[indexPath.row]
        
        
        responseVC.tutorResponse = responses[indexPath.row]
        
        navigationController?.pushViewController(responseVC, animated: true)
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
