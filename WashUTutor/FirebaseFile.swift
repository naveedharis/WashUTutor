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
var currentTutor:Tutor!
var currentStudent:Student!

struct Student {
    var email: String
    var name: String
    var userID: String
    var messages: [String: [String:String]]
}


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

//func studentLoginSign(email: String, password: String) {
//    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//        if let error = error {
//            print("Error signing in: \(error.localizedDescription)")
//        } else {
//            if let user = authResult?.user {
//                // Check if the user's email is verified
//                if user.isEmailVerified {
//                    print("Sign in successful")
//                    // Proceed with signed in user
//                } else {
//                    print("Email is not verified. Please check your email to verify your account.")
//                    // Resend verification email
//                    resendVerificationEmail(user: user)
//                }
//            } else {
//                print("No user data available")
//            }
//        }
//    }
//}

func studentLoginSign(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        guard let user = authResult?.user else {
            let noUserDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user data available"])
            completion(.failure(noUserDataError))
            return
        }
        completion(.success(user))

//
//        if user.isEmailVerified {
//            print("Sign in successful")
//            completion(.success(user))
//        } else {
//            print("Email is not verified. Please check your email to verify your account.")
//            resendVerificationEmail(user: user)
//            let emailNotVerifiedError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email not verified"])
//            completion(.failure(emailNotVerifiedError))
//        }
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
                let id = tutorData!["tutorID"] as? String ?? ""
                let name = tutorData!["name"] as? String ?? ""
                let email = tutorData!["email"] as? String ?? ""
                let year = tutorData!["year"] as? String ?? ""
                let classNumber = tutorData!["classNumber"] as? [String] ?? []
                let messages = tutorData!["messages"] as? [String:[String:String]] ?? [:]
                        currentTutor = Tutor(tutorID: id, name: name, email: email, year: year, classNumber: classNumber, messages: messages)
                        
                        // Assuming you only want the first matching document
                        break
                    }
                    completion(tutorData)
                }
              
    }
}


func getStudentDataTutor(completion: @escaping ([String: Any]?) -> Void){
    let collectionRef = db.collection("students")
    
    if let user = Auth.auth().currentUser {
        let uid = user.uid
        collectionRef.whereField("userID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error getting documents: \(error)")
                completion(nil)
            } else {
                // Query was successful
                // Iterate through the documents to access the data
                var data: [String:Any]?
                for document in querySnapshot!.documents {
                    data = document.data()
                    //print(data)
                    let email = data!["email"] as? String ?? ""
                    let name = data!["name"] as? String ?? ""
                    let id = data!["userID"] as? String ?? ""
                    let messages = data!["messages"] as? [String:[String:String]] ?? [:]
                    currentStudent = Student(email: email, name: name, userID: id, messages: messages)
                    print("CURRENT STUDENT \(currentStudent)")
                    // Assuming you only want the first match
                    // Add a return statement
                    break
                }
                completion(data)
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
    let collectionRef = db.collection("tutorAppointments")
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

func getStudentAppointments(completion: @escaping (Result<[Any], Error>) -> Void) {
    let collectionRef = db.collection("studentAppointments")

    if let user = Auth.auth().currentUser {
        let uid = user.uid

        collectionRef.whereField("studentUserID", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
            } else {
                var dataList: [Any] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    dataList.append(data)
                }
                completion(.success(dataList))
            }
        }
    }
}

func deleteStudentAppointments(appointmentID: String){
    let collectionRef = db.collection("studentAppointments")
    let tutorCollectionRef = db.collection("tutorsAppointment")
    
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
    var messages: [String: [String: String]]
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
                let messages = data["messages"] as? [String: [String: String]] ?? [:]
                // Create a new Tutor object
                let tutor = Tutor(tutorID: id, name: name, email: email, year: year, classNumber: classNumber, messages: messages)
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
    let collectionRef = db.collection("tutorAppointments").whereField("tutorUserID", isEqualTo: tutorID)

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
                    //print(appointment)
                    appointments.append(appointment)
                }

                completion(appointments, nil)
            }
        }
    }



func getStudentNameFromAppointment(appointmentID: String, completion: @escaping (String?, Error?) -> Void) {
    let tutorAppointCollection = db.collection("studentAppointments")
                                    .whereField("appointmentID", isEqualTo: appointmentID)
                                    .whereField("status", isEqualTo: "Booked")

    tutorAppointCollection.getDocuments { (querySnapshot, err) in
        if let err = err {
            completion(nil, err)
        } else if let documents = querySnapshot?.documents, !documents.isEmpty {
            if let studentUserID = documents.first?.data()["studentUserID"] as? String {
                // Nested query to fetch the student's name using the studentUserID
                let studentCollection = db.collection("students").whereField("userID", isEqualTo: studentUserID)
                studentCollection.getDocuments { (QuerySnapshot, err) in
                    if let err = err {
                        completion(nil, err)
                    } else if let documents = QuerySnapshot?.documents, !documents.isEmpty {
                        let studentName = documents.first?.data()["name"] as? String
                        completion(studentName, nil)
                    } else {
                        // Handle the case where no student documents are found
                        completion(nil, nil)
                    }
                }
            } else {
                // Handle the case where the student's user ID isn't found in the document
                completion(nil, nil)
            }
        } else {
            // Handle the case where no appointment documents are found
            completion(nil, nil)
        }
    }
}

//struct Messages {
//    var messageID: String
//    var studentMessage: [String]
//    var tutorMessage: [String]
//    var studentUserID: String
//    var tutorID: String
//}
//
//func addNewMessage(studentMessage: String, studentUserID: String, tutorID: String) {
//
//    let data: [String: Any] = [
//        "messageID": UUID().uuidString,
//        "studentMessage": studentMessage,
//        "studentUserID": studentUserID,
//        "tutorID": tutorID
//        ]
//    let collectionRef = db.collection("studentMessages")
//    collectionRef.addDocument(data: data) { error in
//        if let error = error {
//            print("Error adding document: \(error)")
//        } else {
//            print("Document added with ID: ")
//        }
//    }
//
//
//}

struct Review {
    var reviewID: String
    var review: String
    var ratings: String
    var tutorID: String
}

func addReview(review: String, ratings: String, tutorID: String) {
    let data: [String: Any] = [
        "reviewID" : UUID().uuidString,
        "review" : review,
        "ratings": ratings,
        "tutorID": tutorID
    ]
    
    let collectionRef = db.collection("reviews")
    collectionRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added with ID: ")
        }
    }
}

func addMessageForTutor(tutor:Tutor, messages:[String:[String:String]]){
    
   
    let tutorRef = db.collection("tutors")

    let tutorID = tutorRef.whereField("tutorID", isEqualTo: tutor.tutorID)

    tutorID.getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error.localizedDescription)")
            return
        }

        for document in querySnapshot!.documents {
            let docRef = tutorRef.document(document.documentID)

            var existingMessages = document.data()["messages"] as? [String:[String: String]] ?? [:]

            existingMessages.merge(messages) { (_, new) in new }

            docRef.updateData(["messages": existingMessages]) { error in
                if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated with new messages")
                }
            }
        }
    }
    
}

func addMessagesForStudent(userId: String, messages:[String:[String:String]]) {
    let studentRef = db.collection("students")
    let studentID = studentRef.whereField("userID", isEqualTo: userId)
    
    studentID.getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error.localizedDescription)")
            return
        }

        for document in querySnapshot!.documents {
            let docRef = studentRef.document(document.documentID)

            var existingMessages = document.data()["messages"] as? [String:[String: String]] ?? [:]

            existingMessages.merge(messages) { (_, new) in new }

            docRef.updateData(["messages": existingMessages]) { error in
                if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated with new messages")
                }
            }
        }
    }
}


