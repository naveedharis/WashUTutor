//
//  StudentEditProfileViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 12/1/23.
//

import UIKit

class StudentEditProfileViewController: UIViewController {

    var allClasses: [String] = []
    var xLocation = 0
    var yLocation = 0
    var button = UIButton()
    var tagNumber = 0
    var enrolled: [String] = []

    @IBOutlet weak var editBiography: UITextView!
    
    @IBOutlet weak var coursesView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = currentStudent.name
        contactLabel.text = currentStudent.email
        
        getAllClasses { result in
            switch result {
            case .success(let classDataArray):
                // Use the fetched class data
                DispatchQueue.main.async {
                    self.allClasses = classDataArray.sorted() {$0 < $1}
                    print(self.allClasses)
                    
                    for course in self.allClasses {
                        if course != "All classes" {
                            
                            self.button = UIButton(frame: CGRect(x: self.xLocation, y: self.yLocation, width: 80, height: 30))
                            self.button.setTitle(course, for: .normal)
                            
                            self.button.setTitleColor(.black, for: .normal)
                            self.button.backgroundColor = UIColor.systemGray6
                            
                            self.button.addTarget(self,
                                                  action: #selector(self.selectCourse),
                                             for: .touchUpInside)
                            self.button.tag = self.tagNumber
                                                    
                            self.coursesView.addSubview(self.button)
                            
                            if self.xLocation > 170 {
                                self.xLocation = 0
                                self.yLocation += 35
                            }
                            else {
                                self.xLocation += 85
                                
                            }
                            
                            self.tagNumber += 1
                        }
                        
                    }
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching classes: \(error.localizedDescription)")
            }
        }
        
        
        
    }
    
    @objc
    func selectCourse(sender: UIButton) {
        if sender.backgroundColor == UIColor.systemGray6 {
            print("button pressed")
            
            switch sender.tag {
            case 0:
                sender.backgroundColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
                sender.setTitleColor(.white, for: .normal)
               
                enrolled.append(sender.titleLabel!.text!)
                break
            case 1:
                sender.backgroundColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
                sender.setTitleColor(.white, for: .normal)
                enrolled.append(sender.titleLabel!.text!)
                break
            case 2:
                sender.backgroundColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
                sender.setTitleColor(.white, for: .normal)
                enrolled.append(sender.titleLabel!.text!)
                break
            default:
                print("default")
            }
            print(enrolled)
        }
        else {
            sender.backgroundColor = UIColor.systemGray6
            sender.setTitleColor(.black, for: .normal)
            enrolled.removeAll(where: {$0 == sender.titleLabel!.text})
            print(enrolled)
        }
    }
    
    
    @IBAction func updateProfile(_ sender: Any) {
        updateStudentProfile(userId: currentStudent.userID, enrolled: enrolled, bio: editBiography.text)
        
        currentStudent.courses = enrolled
        currentStudent.biography = editBiography.text
        let studentProfile = storyboard!.instantiateViewController(withIdentifier: "studentProfile") as! StudentProfileViewController
        
        navigationController?.pushViewController(studentProfile, animated: true)
        
        
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
