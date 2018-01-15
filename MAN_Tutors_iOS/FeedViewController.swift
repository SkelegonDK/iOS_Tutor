//
//  FirstViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

	class FeedViewController: UIViewController {
		let darkYellow :UIColor = UIColor(red: 0.553, green: 0.522, blue: 0.043, alpha: 1)
		/// Sets notification access to a default of false
		var isGrantedNotificationAccess = false
		
		/// initializes an unmutable notification object
		func makeNotificationContent() -> UNMutableNotificationContent {
			let content = UNMutableNotificationContent()
			content.title = "Hi " + (Auth.auth().currentUser?.email!)!
			content.body = "You are next, please prepare to be called by a tutor"
			content.userInfo = ["step": 0]
			return content
		}
		
		func callNotificationContent() -> UNMutableNotificationContent {
			let content = UNMutableNotificationContent()
			
			content.title = "Hi! :D"
			content.body = "A tutor is ready for you, please please come to the counter"
			content.userInfo = ["step": 0]
			return content
			
		}
		
		
		func addNotification(trigger:UNNotificationTrigger?,content: UNMutableNotificationContent, identifier: String) {
			let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request) { (error) in
				if error != nil {
					print("error adding notification:\(String(describing: error?.localizedDescription))")
				}
			}
		}
	@IBOutlet weak var tableView: UITableView!
		
	var postArray = [Post]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
			self.isGrantedNotificationAccess = granted
			if !granted {
				// add alert to complain user
			}
		}
		
	}
		
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		DataService.instance.FEED_REF.observe(.value) { (DataSnapshot) in
			
			let user = Auth.auth().currentUser?.uid
			
			DataService.instance.wasUserCalled(forUID: user!, handler: { (returnedString) in
				
				if returnedString == "0" {
				
					if self.isGrantedNotificationAccess == true {
						
						let content = self.callNotificationContent()
						let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
						self.addNotification(trigger: trigger, content: content, identifier: "message.call")
					}
					
				}
				
			})
			
			
			DataService.instance.getFeedData { (returnedPostsArray) in
				
				self.postArray = returnedPostsArray
				
				let next = returnedPostsArray.first
				
				if  next?.senderId == Auth.auth().currentUser?.uid {
					
					if self.isGrantedNotificationAccess == true {
						let content = self.makeNotificationContent()
						let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
						self.addNotification(trigger: trigger, content: content, identifier: "message.next")
					}
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
		return 150
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else { return UITableViewCell() }
		
		let image = UIImage(named: "ic_info_outline_36pt")
		let post = postArray[indexPath.row]

		let number = "You are number " + String(indexPath.row + 1) + " in line"
		
			DataService.instance.getUsername(forUID: post.senderId) { (returnedUserName) in
				cell.configureCell(profileImage: image!, email: returnedUserName, content: post.content,  number: number )
				
		}
		
		if DataService.instance.verifyUrl(urlString: postArray[indexPath.row].postLink) == true {
			
            cell.LinkLbl.isHidden = false
        } else {
            cell.LinkLbl.isHidden = true
        }
		
		
		
		return cell
	}
	/// - ToDo: Add notfication from tutor tu user, to come when tutor X takes studen issue Y
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		let cellLink = postArray[indexPath.row].postLink

        // If URL is valid open url, if not disable interaction
		if DataService.instance.verifyUrl(urlString: cellLink) == true {
            /// - ToDo: add http:// to url paths in database
			let url = URL(string: cellLink )!

            UIApplication.shared.open(url, options: [:])
        } else {

            tableView.isUserInteractionEnabled = false
        }
		
    }
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		/// - ToDo: refactor into function that checks current user with message sender
		let currentUser = Auth.auth().currentUser!
		if (currentUser.uid == postArray[indexPath.row].senderId ) {
			return true
		}
		if currentUser.uid == "Yma031SORqYQUCzFGDF7Todl35C2" {
			return true
		}
			return false
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
		let currentUser = Auth.auth().currentUser?.uid
		
		/// ToDo: call is not called, test function further
		let call = UITableViewRowAction(style: .normal, title: "Call") { (action, indexPath) in
			let senderId = self.postArray[indexPath.row].senderId
			if currentUser == "Yma031SORqYQUCzFGDF7Todl35C2" {
				DataService.instance.makeUserCalled(forUID:senderId , calledState: "1", handler: { (returnedStatus) in
					print(returnedStatus.description)
				})
			}
			
		}
		
		call.backgroundColor = darkYellow
		
		return [delete, call]
	}
}
