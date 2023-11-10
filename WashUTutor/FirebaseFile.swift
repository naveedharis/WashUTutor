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
            if let authResult = authResult {
                // You can access the user's UID like this
                studentUID = authResult.user.uid
                print("userid: \(studentUID ?? "")")
            } else {
                // No user is signed in
                print("No user is signed in.")
            }
            addNewStudent(name: name, email: email, password: password, userID: studentUID ?? "")
        }
    }
    
}

func studentLoginSign(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
        } else {
            print("Sign in")
        }
    }
}

func getTutorData(email: String, code: String){
    let collectionRef = db.collection("tutors")
    
    collectionRef.whereField("tutorID", isEqualTo: code).getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                print(data)
            }
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


