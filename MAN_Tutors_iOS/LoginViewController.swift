//
//  LoginViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//
///ToDo: apply themes to all views
import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextFields_ColorThemer

class LoginViewController: UIViewController {

	@IBOutlet weak var emailInput: MDCTextField!
	@IBOutlet weak var passwordInput: MDCTextField!
	@IBOutlet var signInbtn: MDCRaisedButton!
	@IBOutlet var cancelBtn: MDCButton!
	@IBOutlet var loginView: UIView!
	
	var emailInputController: MDCTextInputControllerOutlined!
   	var passwordInputController: MDCTextInputControllerOutlined!
	
	let colorScheme = ApplicationScheme()
	let appScheme = ApplicationScheme.shared.colorScheme
	
	override func viewDidLoad() {
		loginView.backgroundColor = appScheme.backgroundColor
		
		MDCTextFieldColorThemer.applySemanticColorScheme(colorScheme.textFieldScheme, to: emailInput)
		
		
		emailInputController = MDCTextInputControllerOutlined(textInput: emailInput)
		passwordInputController = MDCTextInputControllerOutlined(textInput: passwordInput)
		
		MDCTextFieldColorThemer.applySemanticColorScheme(appScheme, to: emailInputController)
		MDCTextFieldColorThemer.applySemanticColorScheme(appScheme, to: passwordInputController)
		
		MDCButtonColorThemer.applySemanticColorScheme(appScheme, to: self.signInbtn)
		MDCButtonColorThemer.applySemanticColorScheme(appScheme, to: self.cancelBtn)
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
