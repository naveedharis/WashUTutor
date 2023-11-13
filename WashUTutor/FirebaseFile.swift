//
//  FirebaseFile.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/3/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

let db = Firestore.firestore()
var studentUID: String?


func createAppointment(appointmentID: String, date: String, startTime: String, endTime: String, location: String, subject: String, caption: String){

    let data: [String: Any] = [
        "studentUserID": Auth.auth().currentUser?.uid ?? "",
        "appointmentID": appointmentID,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "location" : location,
        "subject": subject,
        "caption": caption,
        "status": "Booked"
    ]
    let collectionRef = db.collection("studentAppointments")
    collectionRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added with ID: ")
        }
    }
}



func tutorAddAppointment(tutorUserID: String, date: String, startTime: String, announcement: String, endTime: String,  location: String, subject: String){
    let data: [String: Any] = [
        "tutorUserID": tutorUserID,
        "date": date,
        "appointmentID": UUID().uuidString,
        "annoucement": announcement,
        "startTime": startTime,
        "endTime": endTime,
        "location": location,
        "subject": subject,
        "status": "Not booked"
    ]
    let collectionRef = db.collection("tutorAppointments")
    collectionRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added with ID: ")
        }
    }
}


func addNewStudent(name: String, email: String, password: String, userID: String) {
    let data: [String: Any] = [
        "name": name,
        "email": email,
        "password": password,
        "userID": userID
    ]
    let collectionRef = db.collection("students")
    collectionRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added with ID: ")
        }
    }
}

func signUp(name: String, email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error creating user: \(error.localizedDescription)")
        } else {
            print("User created")
            if let user = authResult?.user {
                // You can access the user's UID like this
                let studentUID = user.uid
                print("userid: \(studentUID)")

                // Send verification email
                user.sendEmailVerification { (error) in
                    if let error = error {
                        print("Error sending verification email: \(error.localizedDescription)")
                    } else {
                        print("Verification email sent.")
                    }
                }

                addNewStudent(name: name, email: email, password: password, userID: studentUID)
            } else {
                // No user is signed in
                print("No user is signed in.")
            }
        }
    }
}

func studentLoginSign(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
        } else {
            if let user = authResult?.user {
                // Check if the user's email is verified
                if user.isEmailVerified {
                    print("Sign in successful")
                    // Proceed with signed in user
                } else {
                    print("Email is not verified. Please check your email to verify your account.")
                    // Resend verification email
                    resendVerificationEmail(user: user)
                }
            } else {
                print("No user data available")
            }
        }
    }
}

func resendVerificationEmail(user: User) {
    user.sendEmailVerification { error in
        if let error = error {
            print("Error sending verification email: \(error.localizedDescription)")
        } else {
            print("Verification email resent. Please check your inbox.")
        }
    }
}




func getTutorData(email: String, code: String, completion: @escaping ([String: Any]?) -> Void) {
    let collectionRef = db.collection("tutors")
    
    collectionRef.whereField("tutorID", isEqualTo: code).getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            completion(nil)
        } else {
            var tutorData: [String: Any]?
            for document in querySnapshot!.documents {
                tutorData = document.data()
                // Assuming you only want the first matching document
                break
            }
            completion(tutorData)
        }
    }
}


func getStudentData(){
    let collectionRef = db.collection("students")
    
    if let user = Auth.auth().currentUser {
        let uid = user.uid
        collectionRef.whereField("userID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error getting documents: \(error)")
            } else {
                // Query was successful
                // Iterate through the documents to access the data
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print(data)
                    // Add a return statement
                }
            }
        }
    } else {
        print("no user")
    }
}

func getAllAvailableAppointments(completion: @escaping (Result<[Any], Error>) -> Void) {
    let collectionRef = db.collection("tutorsAppointment")
    collectionRef.whereField("status", isEqualTo: "Not booked").getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            completion(.failure(error))
        } else {
            var appointmentArray: [Any] = []

            for document in querySnapshot!.documents {
                let data = document.data()
                appointmentArray.append(data)
            }
            completion(.success(appointmentArray))
        }
    }
}

func getStudentAppointments(){
    
    let collectionRef = db.collection("studentAppointments")
    
    if let user = Auth.auth().currentUser {
        let uid = user.uid
        
        collectionRef.whereField("studentUserID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error getting documents: \(error)")
            } else {
                var dataList: Array<Any>?
                for document in querySnapshot!.documents {
                    let data = document.data()
                    dataList?.append(data)
                }
            }
        }
    
    }
}

func deleteStudentAppointments(appointmentID: String){
    let collectionRef = db.collection("studentAppointments")
    let tutorCollectionRef = db.collection("tutorAppointment")
    
    if let user = Auth.auth().currentUser {
        let uid = user.uid
        
        collectionRef.whereField("studentUserID", isEqualTo: uid).whereField("appointmentID", isEqualTo: appointmentID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else{
                if let document = querySnapshot?.documents.first {
                    document.reference.delete { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        }
                        else
                        {
                            print("Appointment deleted")
                        }
                    }
                }
                else{
                    print("No appointment found")
                }
            }
        }
    }
    
    tutorCollectionRef.whereField("appointmentID", isEqualTo: appointmentID).getDocuments {
        (QuerySnapshot, error) in
        if let error = error {
            print("Error getting documents \(error)")
        }
        else{
            if let document = QuerySnapshot?.documents.first {
                document.reference.delete { err in
                    if let err = err {
                        print("Error removing documents: \(err)")
                    }
                    else {
                        print("Tutor appointment is deleted")
                    }
                }
            }
            else{
                print("No appointment found")
            }
        }
    }
}

func getAllClasses(completion: @escaping (Result<[String], Error>) -> Void) {
    let collectionRef = db.collection("classes")

    collectionRef.getDocuments { (querySnapshot, err) in
        if let error = err {
            // Pass the error to the completion handler
            completion(.failure(error))
        } else {
            var classDataList: [String] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                classDataList.append(contentsOf: data.keys)
            }
            // Pass the array of class data to the completion handler
            completion(.success(classDataList))
        }
    }
}

struct Tutor {
    var tutorID: String
    var name: String
    var email: String
    var year: String
    var classNumber: [String]
    // Add other properties as needed
}


func AllTutorData(completion: @escaping ([Tutor]?, Error?) -> Void) {
    let collectionRef = db.collection("tutors")

    collectionRef.getDocuments { (querySnapshot, err) in
        if let err = err {
            completion(nil, err)
        } else {
            var tutors = [Tutor]()

            for document in querySnapshot!.documents {
                let data = document.data()
                let id = data["tutorID"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let year = data["year"] as? String ?? ""
                let classNumber = data["classNumber"] as? [String] ?? []
                // Create a new Tutor object
                let tutor = Tutor(tutorID: id, name: name, email: email, year: year, classNumber: classNumber)
                // Append it to the tutors array
                tutors.append(tutor)
            }
            //print(tutors)
            completion(tutors, nil)
        }
    }
}


struct TutorAppointment {
    var tutorID: String
    var Location: String
    var Date: String
    var startTime: String
    var endTime: String
    var annoucement: String
    var appointmentID: String
    var classNumber: String
    var status: String

}

func getAllTutorAppointments(tutorID: String, completion: @escaping ([TutorAppointment]?, Error?) -> Void) {
    let collectionRef = db.collection("tutorsAppointment").whereField("tutorID", isEqualTo: tutorID)

        collectionRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(nil, err)
            } else {
                var appointments = [TutorAppointment]()

                for document in querySnapshot!.documents {
                    let data = document.data()
                    let appointment = TutorAppointment(
                        tutorID: data["tutorID"] as? String ?? "",
                        Location: data["Location"] as? String ?? "",
                        Date: data["Date"] as? String ?? "",
                        startTime: data["startTime"] as? String ?? "",
                        endTime: data["endTime"] as? String ?? "",
                        annoucement: data["annoucement"] as? String ?? "",
                        appointmentID: data["appointmentID"] as? String ?? "",
                        classNumber: data["classNumber"] as? String ?? "",
                        status: data["status"] as? String ?? ""
                        
                        // Initialize other fields as necessary
                    )
                    appointments.append(appointment)
                }

                completion(appointments, nil)
            }
        }
    }



func getStudentNameFromAppointment(appointmentID: String, completion: @escaping (String?, Error?) -> Void){
    let tutorAppointCollection = db.collection("studentAppointments").whereField("appointmentID", isEqualTo: appointmentID)
    let studentCollection = db.collection("students")
    

    tutorAppointCollection.getDocuments { (querySnapshot, err) in
        if let err = err {
            completion(nil, err)
        } else {
            var appointment = querySnapshot!.documents[0].data()
            print(appointment)
        }
        
        
    }
}


