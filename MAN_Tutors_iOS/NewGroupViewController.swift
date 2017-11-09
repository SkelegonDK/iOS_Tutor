//
//  NewGroupViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 03/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

class NewGroupViewController: UIViewController {

	
	@IBOutlet weak var SubjecField: UITextField!
	@IBOutlet weak var DescriptionField: UITextField!
	@IBOutlet weak var SearchField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var groupMemberLbl: UILabel!
	@IBOutlet weak var createBtn: UIButton!
		
	var emailArray = [String]()
	var chosenUserArray = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		self.tableView.tableFooterView = UIView()
		
		SearchField.delegate = self
		SearchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		createBtn.isHidden = true
	}
	///calls or query function when text is changed
	@objc func textFieldDidChange() {
		if SearchField.text == "" {
			emailArray = []
			tableView.reloadData()
		} else {
			DataService.instance.getEmail(forSearchQuery: SearchField.text!, handler: {(returnedEmailArray) in
				self.emailArray = returnedEmailArray
				self.tableView.reloadData()
			})
		}
	}

	
	@IBAction func CreateBtnAction(_ sender: Any) {
		if SubjecField.text != "" && DescriptionField.text != "" {
			DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (idArray) in
				var userIDs = idArray
				userIDs.append((Auth.auth().currentUser?.uid)!)
				DataService.instance.createGroup(withTitle: self.SubjecField.text!, andDescription: self.DescriptionField.text!, forUserIds: userIDs, handler: { (groupCreated) in
					if groupCreated {
//							self.createBtn.isHidden = false
						self.dismiss(animated: true, completion: nil)
					} else {
						print("group could not be created")
					}
				})
			})
		}
	}
	
	@IBAction func BackBtnAction(_ sender: Any) {
		
		dismiss(animated: true, completion: nil)
	}
	

}

extension NewGroupViewController: UITableViewDelegate, UITableViewDataSource {

	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return emailArray.count
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else {return UITableViewCell()}
		let userImage = UIImage(named: "first")
//		emailArray = ["tutor@example.com","student@example.com","cssMaster@example.com"]
		cell.configureCell(userImage: userImage!, email: emailArray[indexPath.row], isSelected: false)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {return}
		
		if !chosenUserArray.contains(cell.userNameLbl.text!) {
			chosenUserArray.append(cell.userNameLbl.text!)
			groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
			createBtn.isHidden = false
		} else {
			chosenUserArray = chosenUserArray.filter({ $0 != cell.userNameLbl.text! })
			if chosenUserArray.count >= 1 {
				groupMemberLbl.text = chosenUserArray.joined(separator: ", ")
				//print(String(describing: chosenUserArray))
			} else {
				groupMemberLbl.text = "add users to group"
				createBtn.isHidden = true
			}
		}
	}
}

extension NewGroupViewController: UITextFieldDelegate {
	
	
	
}
