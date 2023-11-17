//
//  tutorProfileViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/17/23.
//

import UIKit
import SwiftUI
import Cosmos

class tutorProfileViewController: UIViewController {

    @AppStorage("tutorID") var tutorID = ""
    @IBOutlet weak var tutorNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratings: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratings.rating = 4
        tutorNameLabel.text = "Haris Naveed"
        yearLabel.text = "Junior"
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
