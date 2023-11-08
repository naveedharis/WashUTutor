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

let db = Firestore.firestore()
var studentUID: String?


func createAppointment(studentUserID: String, tutorUserID: String, startTime: String, endTime: String, location: String, subject: String, caption: String){
    let data: [String: Any] = [
        "studentUserID": studentUserID,
        "tutorUserID": tutorUserID,
        "startTime": startTime,
        "endTime": endTime,
        "location" : location,
        "subject": subject,
        "caption": caption
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

func tutorAddAppointment(tutorUserID: String, startTime: String, endTime: String,  location: String, subject: String, status: Int){
    let data: [String: Any] = [
        "tutorUserID": tutorUserID,
        "startTime": startTime,
        "endTime": endTime,
        "location": location,
        "subject": subject,
        "status": status
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


func addNewStudent(name: String, email: String, password: String) {
    let data: [String: Any] = [
        "name": name,
        "email": email,
        "password": password
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

func signUp(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error creating user: \(error.localizedDescription)")
        } else {
            print("User created")
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
    if let user = Auth.auth().currentUser {
        // You can access the user's UID like this
        studentUID = user.uid
        print("userid: \(studentUID ?? "")")
    } else {
        // No user is signed in
        print("No user is signed in.")
    }
}
