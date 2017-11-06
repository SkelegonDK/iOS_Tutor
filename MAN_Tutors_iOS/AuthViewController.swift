//
//  AuthViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		if Auth.auth().currentUser != nil {
			dismiss(animated: true, completion: nil)
		}
	}
    
	@IBAction func EmailBtnAction(_ sender: Any) {
		
		let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
		present(loginViewController!, animated: true,completion: nil)
		
	}
	
}
