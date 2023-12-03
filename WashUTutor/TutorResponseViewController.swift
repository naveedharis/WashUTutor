//
//  TutorResponseViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/14/23.
//

import UIKit

class TutorResponseViewController: UIViewController {

    var studentQuestion:String!
    var tutorResponse:String!
    var markAsAnswered: UITextField!
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var responseBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionBox.text = studentQuestion
        
       
        responseBox.text = tutorResponse
        
        
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func sendResponse(_ sender: Any) {
        
//        updateStudent(userId: currentTutor.messages[questionBox.text]!["userId"]!)
        currentTutor.messages[questionBox.text]!["response"] = responseBox.text
        
        var sendResponseToStudent: [String:[String:String]] = [questionBox.text:["userId": currentTutor.messages[questionBox.text]?["userId"] ?? "", "response": responseBox.text]]
        
        addMessageForTutor(tutor: currentTutor, messages: currentTutor.messages)
       
        addMessagesForStudent(userId: currentTutor.messages[questionBox.text]!["userId"]!, messages: sendResponseToStudent)

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
