//
//  DataService.swift
//  Outings
//
//  Created by Ryan Hennings on 11/12/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import Foundation
import FirebaseFirestore

// Make Database globally accesible
let DB_BASE = Firestore.firestore()

class DataService {
    
    // Singleton
    static let dataStorage = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_OUTINGS = DB_BASE.collection("outings")
    private var _REF_USERS = DB_BASE.collection("users")
    
    var currentUserID: String?
    
    var REF_BASE: Firestore              { return _REF_BASE }
    var REF_OUTINGS: CollectionReference { return _REF_OUTINGS }
    var REF_USERS: CollectionReference   { return _REF_USERS }
    
    
    
    
    func createFirestoreDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.document(uid).setData(userData) { (error) in
            if error != nil {
                print("RYAN: Error adding user document - error: \(String(describing: error))")
            }
        }
        currentUserID = uid
        
//        addDocument(data: userData) { (error) in
//            if error != nil {
//                print("RYAN: Error adding user document - error: \(String(describing: error))")
//            }
//        }
    }
    
    
    
}
