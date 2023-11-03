//
//  FirebaseFile.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/3/23.
//

import Foundation
import Firebase
import FirebaseAuth

let db = Firestore.firestore()
var userUID: String?

func signUp(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error creating user: \(error.localizedDescription)")
        } else {
            print("User created")
        }
    }
}

func loginSign(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
        } else {
            print("Sign in")
        }
    }
    if let user = Auth.auth().currentUser {
        // You can access the user's UID like this
        userUID = user.uid
        print("userid: \(userUID ?? "")")
    } else {
        // No user is signed in
        print("No user is signed in.")
    }
}
