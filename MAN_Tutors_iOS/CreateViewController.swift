//
//  CreateViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

class CreateViewController: UIViewController, UITextViewDelegate {

	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userEmail: UILabel!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var SendBtn: UIButton!
	@IBOutlet weak var LinkTextField: UITextField!
	
	
	let darkYellow :UIColor = UIColor(red: 0.553, green: 0.522, blue: 0.043, alpha: 1)
	let textViewPlaceholder: String = "Tap to write or swipe down keyboard\nPlease write a short description of your issue..."
 	override func viewDidLoad() {
		super.viewDidLoad()
		self.textView.delegate = self
		
		textView.text = textViewPlaceholder
		textView.textColor = darkYellow
	
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.userEmail.text = Auth.auth().currentUser?.email
	}
	
	// is Necessary?
	// TODO: functions deletes text when tapping on linkTextField
	func textViewDidEndEditing(_ textView: UITextView) {
//		textView.text = textViewPlaceholder
		textView.textColor = darkYellow
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
//		textView.text = ""
		textView.textColor = UIColor.black
	}
	
	
	@IBAction func SendBtnAction(_ sender: Any) {
		
		if textView.text != nil && textView.text != textViewPlaceholder  {
			SendBtn.isEnabled = false
			
			// TODO: fix create function PostLink reference
			DataService.instance.createPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, withLink: LinkTextField.text!   , sendComplete:
				{(isComplete) in if isComplete {
					
					self.SendBtn.isEnabled = true
					self.dismiss(animated: true, completion: nil)
				
				} else {

					self.SendBtn.isEnabled = true
					print("error")
				}
			})
			
			
		}
		textView.resignFirstResponder()
	}
	
	@IBAction func BackBtnAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func SwipeDownKeyboardGesture(_ sender: Any) {
		textView.resignFirstResponder()
	}
}

