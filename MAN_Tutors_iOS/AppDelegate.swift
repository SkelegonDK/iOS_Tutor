//
//  AppDelegate.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//
import Foundation
import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()

		if Auth.auth().currentUser == nil {
			let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
			let authView = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
			window?.makeKeyAndVisible()
			window?.rootViewController?.present(authView,animated: true,completion: nil)
			
		}
		return true
	}
	
}
