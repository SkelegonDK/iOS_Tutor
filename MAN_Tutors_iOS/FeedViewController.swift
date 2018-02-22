//
//  FirstViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase
//import UserNotifications

class FeedViewController: UIViewController {
	let cellSpacingHeight : CGFloat = 20
	let darkYellow :UIColor = UIColor(red: 0.553, green: 0.522, blue: 0.043, alpha: 1)

	@IBOutlet weak var tableView: UITableView!
	
	var postArray = [Post]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		DataService.instance.FEED_REF.observe(.value) { (DataSnapshot) in
			
			let user = Auth.auth().currentUser?.uid
			
			DataService.instance.getFeedData { (returnedPostsArray) in
				
				self.postArray = returnedPostsArray
				
				let next = returnedPostsArray.first
				
				if  next?.senderId == Auth.auth().currentUser?.uid {
					
				}
				
				self.tableView.reloadData()
				
			}
		}
	}
	
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postArray.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 170
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else { return UITableViewCell() }
		
		
		let image = UIImage(named: "ic_info_outline_36pt")
		let post = postArray[indexPath.row]
		
		let number = "You are number " + String(indexPath.row + 1) + " in line"
		
		DataService.instance.getUsername(forUID: post.senderId) { (returnedUserName) in
			cell.configureCell(profileImage: image!, email: returnedUserName, content: post.content,  number: number )
			
		}
		
		if postArray[indexPath.row].postLink == "http://" || postArray[indexPath.row].postLink == "" {
			
			cell.LinkLbl.isHidden = true
		} else {
			if DataService.instance.verifyUrl(urlString: postArray[indexPath.row].postLink) == true {
				
				cell.LinkLbl.isHidden = false
			} else {
				cell.LinkLbl.isHidden = true
			}
			
		}
		
		return cell
	}
	/// - ToDo: Add notfication from tutor tu user, to come when tutor X takes studen issue Y
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let cellLink = postArray[indexPath.row].postLink
		
		if cellLink == "http://" || cellLink == "" {
			
			tableView.isUserInteractionEnabled = false
		} else {
			// If URL is valid open url, if not disable interaction
			if DataService.instance.verifyUrl(urlString: cellLink) == true {
				/// - ToDo: add http:// to url paths in database
				let url = URL(string: cellLink )!
				
				UIApplication.shared.open(url, options: [:])
			} else {
				
				tableView.isUserInteractionEnabled = false
			}
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		/// - ToDo: refactor into function that checks current user with message sender
		let currentUser = Auth.auth().currentUser!
		if (currentUser.uid == postArray[indexPath.row].senderId || currentUser.uid == "Yma031SORqYQUCzFGDF7Todl35C2" ) {
			return true
		} else {
		return false
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
			//handle delete (by removing the data from your array and updating the tableview
			
			print("delete")
			let deletedPost = self.postArray[indexPath.row].postId
			let senderId = self.postArray[indexPath.row].senderId
			
			DataService.instance.makeUserCalled(forUID: senderId, calledState: "0", handler: { (returnedStatus) in
				print(returnedStatus.description)
			})
			DataService.instance.deletePost(forUID: deletedPost, forSenderId: senderId, sendComplete: { (true) in
				print("deleted" + deletedPost)
				
			})
			
			self.postArray.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .bottom)
			self.tableView.reloadData()
			
		}
		
		
		/// ToDo: call is not called, test function further
		let call = UITableViewRowAction(style: .normal, title: "Call") { (action, indexPath) in
			let senderId = self.postArray[indexPath.row].senderId

		}
		
		call.backgroundColor = darkYellow
		
		return [delete, call]
	}
}
