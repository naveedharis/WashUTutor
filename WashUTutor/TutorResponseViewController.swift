//
//  TutorResponseViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/14/23.
//

import UIKit
import SwiftUI

class TutorResponseViewController: UIViewController, UITextViewDelegate {

    var studentQuestion:String!
    var tutorResponse:String!
    var markAsAnswered: UITextField!
    var questionKey: String!
    @AppStorage("tutorID") var tutorID = ""
    @AppStorage("tutorName") var tutorName = ""


    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var responseBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionBox.text = studentQuestion
        responseBox.text = tutorResponse
        
        responseBox.delegate = self
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
           textView.resignFirstResponder()
           return true
       }
       
   @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    @IBAction func sendResponse(_ sender: Any) {
        
//        updateStudent(userId: currentTutor.messages[questionBox.text]!["userId"]!)
        currentTutor.messages[questionKey]!["response"] = responseBox.text
        
        let sendResponseToStudent: [String:[String:String]] = [questionKey:["userId": currentTutor.messages[questionKey]?["userId"] ?? "", "question": studentQuestion, "response": responseBox.text, "tutorID": tutorID, "tutorName": tutorName]]
        
        addMessageForTutor(tutor: currentTutor, messages: currentTutor.messages)
       
        addMessagesForStudent(userId: currentTutor.messages[questionKey]!["userId"]!, tutorID: tutorID, tutorName: tutorName, messages: sendResponseToStudent)

        let inboxVC = storyboard!.instantiateViewController(withIdentifier: "tutorInbox") as! TutorMessagesViewController
        
        navigationController?.pushViewController(inboxVC, animated: true)
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
