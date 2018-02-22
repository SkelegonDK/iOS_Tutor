//
//  UserViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

//	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userEmoji: UILabel!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var AdminView: ViewShadow!
	@IBOutlet weak var AdminLbl: UILabel!
	@IBOutlet weak var StudentView: ViewShadow!
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		/// Hides Admin view if user is not admin
		self.AdminView.isHidden = true
		
		self.userName.text = Auth.auth().currentUser?.email
		self.userEmoji.text = "Student " + "💻🔥💪"
		self.AdminLbl.text = "Admin " + "🔥📖🔥"
		
		/// If user is admin show admin view
		if (self.userName.text == "tutor@tutor.com") {
			self.AdminView.isHidden = false;
		}
	}
	
	
	@IBAction func LogoutBtnAction(_ sender: Any) {
		
		/// Cancel logout action
		let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (Btntapped) in
			
		}
	
		let logOutMessage = UIAlertController(title: "Confirm logout", message: "Are you sure?", preferredStyle: .actionSheet)
		
		let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (BtnTapped) in
			do {
				try Auth.auth().signOut()
				let AuthVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
				self.present(AuthVC!, animated:true, completion:nil)
			} catch {
				print(error)
			}
			
		}
		logOutMessage.addAction(CancelAction)
		logOutMessage.addAction(logOutAction)
		present(logOutMessage,animated: true,completion: nil)
	}
	
}
