//
//  DataService.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import Foundation
import Firebase

let DB_ROOT = Database.database().reference()

class DataService {
	static let instance = DataService()
	
	private var _ROOT_REF = DB_ROOT
	private var _USERS_REF = DB_ROOT.child("users")
	private var _GROUPS_REF = DB_ROOT.child("groups")
	private var _FEED_REF = DB_ROOT.child("feed")
	private var _IMAGES_REF = DB_ROOT.child("images")

	var ROOT_REF: DatabaseReference {
		return _ROOT_REF
	}
	var USERS_REF: DatabaseReference {
		return _USERS_REF
	}
	var GROUPS_REF: DatabaseReference {
		return _GROUPS_REF
	}
	var FEED_REF: DatabaseReference {
		return _FEED_REF
	}
	var IMAGES_REF: DatabaseReference {
		return _IMAGES_REF
	}
	
	func createUser(uid:String,userData: Dictionary<String,Any>) {
		USERS_REF.child(uid).updateChildValues(userData)
		
	}
	
	func createPost(withMessage message: String, forUID uid:String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool)->()) {
		if groupKey != nil {
			
		} else {
			FEED_REF.childByAutoId().updateChildValues(["content":message, "senderId": uid])
			sendComplete(true)
		}
	}
	
	func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
		
		USERS_REF.observeSingleEvent(of: .value, with: { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
			for user in userSnapshot {
				if user.key == uid {
					handler(user.childSnapshot(forPath: "email").value as! String)
				}
			}
		})
	}
	
	func getFeedData(handler: @escaping(_ posts:[Post]) -> ()) {
		var postArray = [Post]()
		FEED_REF.observeSingleEvent(of: .value, with: { (postFeedSnapshot) in
			guard let postFeedSnapshot = postFeedSnapshot.children.allObjects as? [DataSnapshot] else { return }
			
			for post in postFeedSnapshot {
				let content = post.childSnapshot(forPath: "content").value as! String
				let senderId = post.childSnapshot(forPath: "senderId").value as! String
				let post = Post(content: content, senderId: senderId)
				postArray.append(post)
			}
			
			handler(postArray)
		})
	}
	
	func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) ->()) {
		var emailArray = [String]()
		USERS_REF.observeSingleEvent(of: .value, with: { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
			for user in userSnapshot {
				if group.members.contains(user.key) {
					let email = user.childSnapshot(forPath: "email").value as! String
					emailArray.append(email)
				}
			}
			handler(emailArray)
		})
	}
	/// Email search function
	func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
		var emailArray = [String]()
		USERS_REF.observe(.value, with: { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
			for user in userSnapshot {
				let email = user.childSnapshot(forPath: "email").value as? String
				
				if email?.contains(query) == true && email != Auth.auth().currentUser?.email {
					emailArray.append(email!)
				}
			}
			handler(emailArray)
		})
	}
	
	func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
		USERS_REF.observeSingleEvent(of: .value, with: { (userSnapshot) in
			var idArray = [String]()
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
			for user in userSnapshot {
				let email = user.childSnapshot(forPath: "email").value as! String
				
				if usernames.contains(email) {
					idArray.append(user.key)
				}
			}
			handler(idArray)
		})
	}
	
	func createGroup(withTitle title: String, andDescription description: String, forUserIds Ids: [String], handler: @escaping(_ groupCreated: Bool)->()) {
		GROUPS_REF.childByAutoId().updateChildValues(["title":title,"description":description,"members":Ids])
		handler(true)
	}
	
	func getAllMessagesFor(group: Group, handler: @escaping (_ messageArray: [Post]) -> ()) {
		var messageArray = [Post]()
		
		GROUPS_REF.child(group.key).child("messages").observeSingleEvent(of: .value, with: { (groupMessageSnapshot) in
			
			guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
			for groupMessage in groupMessageSnapshot {
				let content = groupMessage.childSnapshot(forPath: "messages").value as! String
				let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
				let message = Post(content: content, senderId: senderId)
				messageArray.append(message)
			}
			handler(messageArray)
		})
			
	}
	
	
	func uploadPost(withPost post: String, forUID uid: String, withgroupKey groupKey: String?,sendComplete: @escaping (_ status: Bool) -> ()) {
		if groupKey != nil {
			GROUPS_REF.child(groupKey!).child("messages").childByAutoId().updateChildValues(["messages": post,"senderId":uid])
			sendComplete(true)
		} else {
			FEED_REF.childByAutoId().updateChildValues(["content": post,"senderId":uid])
			sendComplete(true)
		}
	}
	
	
	func getAllGroups(handler: @escaping (_ groupsArray: [Group])->()) {
		var groupsArray = [Group]()
		GROUPS_REF.observeSingleEvent(of: .value, with: { (groupSnapshot) in
			guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
			
			print(String(describing: groupSnapshot))
			for group in groupSnapshot {
				let memberArray = group.childSnapshot(forPath: "members").value as! [String]
				if memberArray.contains((Auth.auth().currentUser?.uid)!) {
					let title = group.childSnapshot(forPath: "title").value as! String
					let description = group.childSnapshot(forPath: "description").value as! String
					let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
					groupsArray.append(group)
				}
			}
			handler(groupsArray)
		})
	}
	


}

