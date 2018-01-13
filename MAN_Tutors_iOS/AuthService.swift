//
//  AuthService.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
	static let instance = AuthService()
	
	// @escaping If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is escaping. It is also said that the closure argument escapes the function body.
	/// Takes an email and a password and creates a user using the Firebase Auth method createUser.
	func registerUser(withEmail email: String, andPassword password: String, userCreated: @escaping(_ status: Bool , _ error:Error?)->()) {
		Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
			// throw error if nil
			guard let user = user else {
			userCreated(false,error)
				return
		}
			let userData = ["provider": user.providerID, "email": user.email]
			DataService.instance.createUser(uid:user.uid, userData: userData)
			userCreated(true,nil)
		}

	}
	/// Takes email and password and returns a true if the login is successfull
	func LoginUser(withEmail email: String, andPassword password: String, loginAccepted: @escaping(_ status: Bool , _ error:Error?)->()) {
		Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
		 if error != nil {
			loginAccepted(false,error)
			return
			}
		loginAccepted(true,nil)
		}
	}
}
