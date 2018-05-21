//
//  LoginViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextFields_ColorThemer

class LoginViewController: UIViewController {

	@IBOutlet weak var emailInput: MDCTextField!
	@IBOutlet weak var passwordInput: MDCTextField!
	
	var emailInputController: MDCTextInputControllerOutlined!
   	var passwordInputController: MDCTextInputControllerOutlined!
	
	let colorScheme = MDCSemanticColorScheme()
	
	override func viewDidLoad() {
		emailInputController = MDCTextInputControllerOutlined(textInput: emailInput)
		passwordInputController = MDCTextInputControllerOutlined(textInput: passwordInput)
		super.viewDidLoad()
		
    }
	
	@IBAction func EnterBtnAction(_ sender: Any) {
		if (emailInput.text != nil) && (passwordInput.text != nil) {
			AuthService.instance.LoginUser(withEmail: emailInput.text!, andPassword: passwordInput.text!, loginAccepted: {(success, loginError) in
				if success {
					self.dismiss(animated: true, completion: nil)
				} else {
					print(String(describing: loginError?.localizedDescription))
				}
				AuthService.instance.registerUser(withEmail: self.emailInput.text!, andPassword: self.passwordInput.text! , userCreated: { (success, regError) in
					if success {
					AuthService.instance.LoginUser(withEmail: self.emailInput.text!, andPassword: self.passwordInput.text!, loginAccepted: { (success, nil) in
						self.dismiss(animated: true, completion: nil)
						//print("registered user")
					})
				}else {
					print(String(describing: regError?.localizedDescription))
					}
			 
			})
				})
		}
	}
	@IBAction func CancelBtnAction(_ sender: Any) {
		
	}
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}
