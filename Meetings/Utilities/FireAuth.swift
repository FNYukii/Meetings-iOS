//
//  FireAuth.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import FirebaseAuth

class FireAuth {
    
    static func isSignedIn() -> Bool {
        let user = Auth.auth().currentUser
        if user != nil {
            return true
        }
        return false
    }
    
    static func userId() -> String? {
        let user = Auth.auth().currentUser
        if let user = user {
            return user.uid
        }
        return nil
    }
    
    static func userEmail() -> String? {
        let email = Auth.auth().currentUser?.email
        if let email = email {
            return email
        }
        return nil
    }
    
    static func signUp(email: String, password: String, completion: ((String?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("HELLO! Fail! Erroring sign up. error: \(error)")
            }
            if let authResult = authResult {
                let userId = authResult.user.uid
                completion?(userId)
            }
        }
    }
    
    static func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("HELLO! Fail! Erroring sign in. error: \(error)")
            }
        }
    }
    
    static func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
