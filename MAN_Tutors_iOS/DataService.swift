//  DataService.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
/// - ToDo: Dokument functions

import Foundation
import Firebase
	/// Database class reference
let DB_ROOT = Database.database().reference()

/// Database class methods
class DataService {
	
	static let instance = DataService()
	
	private var _ROOT_REF = DB_ROOT
	private var _USERS_REF = DB_ROOT.child("users")
//	private var _GROUPS_REF = DB_ROOT.child("groups")
	private var _FEED_REF = DB_ROOT.child("feed")
//	private var _IMAGES_REF = DB_ROOT.child("images")
	private var _INFO_REF = DB_ROOT.child("info")
	/// Database root reference
	var ROOT_REF: DatabaseReference {
		return _ROOT_REF
	}
	/// Database users reference
	var USERS_REF: DatabaseReference {
		return _USERS_REF
	}
	
	/// Database feed reference
	var FEED_REF: DatabaseReference {
		return _FEED_REF
	}
	var INFO_REF: DatabaseReference {
		return _INFO_REF
	}
	/// - ToDo: delete image functionality
	/// Database Image reference
//	var IMAGES_REF: DatabaseReference {
//		return _IMAGES_REF
//	}
	
	///Creates a user with a UID and appends it to a dictionary of user data
	func createUser(uid:String,userData: Dictionary<String,Any>) {
		USERS_REF.child(uid).updateChildValues(userData)
	}
	
	
	
	/// Creates post with a message, a UID and a link. Firebase automatically creates a unique key for the message, and it takes the sending users key as UID
	/// - parameter message: a string with the users message
	/// - parameter uid: a string with the senders unique databse key
	/// - parameter postLink: a string with an optional link
func createPost(withMessage message: String, forUID uid:String, postLink: String, sendComplete: @escaping (_ status: Bool)->()) {
	
			FEED_REF.childByAutoId().updateChildValues(["content":message, "senderId": uid, "link": postLink])
			sendComplete(true)
	
	}
	
    /// Function checks post id against current user id, before deleting the post object from the database
	func deletePost(forUID uid: String, forSenderId senderId: String, sendComplete:@escaping(_ status: Bool) -> ()) {
		if (senderId == Auth.auth().currentUser!.uid) || Auth.auth().currentUser!.uid == "Yma031SORqYQUCzFGDF7Todl35C2" {
		FEED_REF.child(uid).removeValue()
			
		}
		
    }
	
	
	
	/// Function gets user id from DB reference and returns user email adress.
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
	/// ToDo: remove
	func wasUserCalled(forUID uid: String, handler: @escaping (_ userCalled: String) -> ()) {
		USERS_REF.observeSingleEvent(of: .value, with: { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
			for user in userSnapshot {
				if user.key == uid {
					handler(user.childSnapshot(forPath: "called").value as! String)
				}
			}
		})
	}
	
	func makeUserCalled(forUID uid: String, calledState status:String, handler: @escaping (_ userCalled: String) -> ()) {
		USERS_REF.observeSingleEvent(of: .value, with: { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
			for user in userSnapshot {
				if user.key == uid {
					self.USERS_REF.child(uid).updateChildValues(["called" : status])
				}
			}
		})
	}
	
	
	/// Function gets post data from DB reference. Then a post array is created to hold all the posts. Then the data is assigned to the Post data model. Then the handler returs a post array that the app can use.
	func getFeedData(handler: @escaping(_ posts:[Post]) -> ()) {
		var postArray = [Post]()
		FEED_REF.observeSingleEvent(of: .value, with: { (postFeedSnapshot) in
			
			guard let postFeedSnapshot = postFeedSnapshot.children.allObjects as? [DataSnapshot] else { return }
			
			for post in postFeedSnapshot {
				let content = post.childSnapshot(forPath: "content").value as! String
				let senderId = post.childSnapshot(forPath: "senderId").value as! String
				let postLink = post.childSnapshot(forPath: "link").value as! String
				/// PostId is necessary for effective post identification/deletion, but not vital to the program
				let postId = post.key
				let post = Post(content: content, senderId: senderId, postId:postId, postLink: postLink)
				postArray.append(post)
			}
			
			handler(postArray)
		})
	}
	
	/// Function gets all info data from database
	func getInfoData(handler: @escaping(_ infos:[String]) -> ()) {
		var infoArray = [String]()
		
		INFO_REF.observeSingleEvent(of: .value) { (infoSnapshot) in
			guard let infoSnapshot = infoSnapshot.children.allObjects as? [DataSnapshot] else { return }
			
			for info in infoSnapshot {
				let content = info.childSnapshot(forPath: "content").value as! String
				infoArray.append(content)
			}
			handler(infoArray)
		}
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
	
//	func createGroup(withTitle title: String, andDescription description: String, forUserIds Ids: [String], handler: @escaping(_ groupCreated: Bool)->()) {
//		GROUPS_REF.childByAutoId().updateChildValues(["title":title,"description":description,"members":Ids])
//		handler(true)
//	}
	
//	func getAllMessagesFor(group: Group, handler: @escaping (_ messageArray: [Post]) -> ()) {
//		var messageArray = [Post]()
//		
//		GROUPS_REF.child(group.key).child("messages").observeSingleEvent(of: .value, with: { (groupMessageSnapshot) in
//			
//			guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
//			for groupMessage in groupMessageSnapshot {
//				let content = groupMessage.childSnapshot(forPath: "messages").value as! String
//				let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
//				let postId = groupMessage.key
//				let postLink = groupMessage.childSnapshot(forPath: "link").value as! String
//				let message = Post(content: content, senderId: senderId,postId: postId,postLink: postLink)
//				messageArray.append(message)
//			}
//			handler(messageArray)
//		})
//			
//	}
	
	
    /// Takes values from Post model. Then uploads to child feed reference.
	func uploadPost(withPost post: String, forUID uid: String, withgroupKey groupKey: String?,withLink postLink: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
		if groupKey != nil {

		} else {
			FEED_REF.childByAutoId().updateChildValues(["content": post,"senderId":uid,"link":postLink ?? ""])
			sendComplete(true)
		}
	}
	
	
//	func getAllGroups(handler: @escaping (_ groupsArray: [Group])->()) {
//		var groupsArray = [Group]()
//		GROUPS_REF.observeSingleEvent(of: .value, with: { (groupSnapshot) in
//			guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
//			
//			//print(String(describing: groupSnapshot))
//			for group in groupSnapshot {
//				let memberArray = group.childSnapshot(forPath: "members").value as! [String]
//				if memberArray.contains((Auth.auth().currentUser?.uid)!) {
//					let title = group.childSnapshot(forPath: "title").value as! String
//					let description = group.childSnapshot(forPath: "description").value as! String
//					let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
//					groupsArray.append(group)
//				}
//			}
//			handler(groupsArray)
//		})
//	}

    /// Function verifies if postLink URL is a valid URL.
	/// - parameter urlString:string of the link checked
	/// - returns:if URL is valid returns true
    func verifyUrl(urlString: String?) -> Bool {
		
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
	


}

