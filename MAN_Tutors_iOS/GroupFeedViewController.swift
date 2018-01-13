//
//  GroupFeedViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 10/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sendBtn: UIButton!
	@IBOutlet weak var groupTitleLbl: UILabel!
	@IBOutlet weak var membersLbl: UILabel!
    
	var group: Group?
	var groupMessages = [Post]()
	
	func initData(forGroup group: Group) {
		self.group = group
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
        // enable table row cells to adjust cell height automatically if necessary
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		groupTitleLbl.text = group?.groupTitle
		DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
			self.membersLbl.text = returnedEmails.joined(separator: ", ")
		
		}
		
//		DataService.instance.GROUPS_REF.observe(.value, with: { (snapshot) in
//			DataService.instance.getAllMessagesFor(group: self.group!) { (returnedGroupMessages) in
//                self.groupMessages = returnedGroupMessages.reversed()
//				self.tableView.reloadData()
//			}
//		})
		
		
		
	}
	
//	@IBAction func sendBtnWasPressed(_ sender: Any) {
//		if postTextField.text != "" {
//			postTextField.isEnabled = false
//			sendBtn.isEnabled = false
//			//FIXME: missing withLink argument and missing texfield in group message
//			DataService.instance.uploadPost(withPost: postTextField.text!, forUID: Auth.auth().currentUser!.uid , withgroupKey: group?.key, sendComplete: { (complete) in
//				if complete {
//					self.postTextField.text = ""
//					self.postTextField.isEnabled = true
//					self.sendBtn.isEnabled = true
//
//				}
//			})
//		}
//	}

		@IBAction func sendBtnWasPressed(_ sender: Any) {
            
		}
	
	
	@IBAction func backBtnWasPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
}
extension GroupFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 150
//    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupMessages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
		let message = groupMessages[indexPath.row]
		
        
        // Verify is url is valid, if valid true show LinkLbl
        if message.postLink == "" {
         cell.LinkLbl.isHidden = true
        } else {
            cell.LinkLbl.isHidden = false
        }

		DataService.instance.getUsername(forUID: message.senderId) { (email) in
			cell.configureCell(profileImage: #imageLiteral(resourceName: "second"), email: email, content: message.content)
		}
		return cell
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellLink = groupMessages[indexPath.row].postLink
        /// - ToDo: If URL is empty, if not disable interaction
        let url =  URL(string: cellLink )!
        
        UIApplication.shared.open(url, options: [:])
        
    }
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		/// - ToDo: refactor into function that checks current user with message sender
		let currentUser = Auth.auth().currentUser!
		if (currentUser.uid == groupMessages[indexPath.row].senderId) {
			return true
		}
		return false
	}
	
    /// - ToDo: if URL is not valid, delete from database
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			// handle delete (by removing the data from your array and updating the tableview
			
			
			let deletedPost = groupMessages[indexPath.row].postId
			let senderId = groupMessages[indexPath.row].senderId
			//print(deletedPost)
			
			DataService.instance.deletePost(forUID: deletedPost, forSenderId: senderId, sendComplete: { (true) in
				print("deleted" + deletedPost)
				
			})
			self.groupMessages.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .bottom)
			self.tableView.reloadData()
		}
		
	}
	
    /// - ToDo: move function to Dataservice object so it can be accessed globally
    /// Checks if a URL string is a valid URL and returns a boolean value
	
}


