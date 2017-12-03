//
//  FirstViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase

	class FeedViewController: UIViewController {

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
			
			DataService.instance.getFeedData { (returnedPostsArray) in
				self.postArray = returnedPostsArray
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
		
		let image = UIImage(named: "issue-29")
		let post = postArray[indexPath.row]

		let number = "You are number " + String(indexPath.row + 1) + " in line"
		
			DataService.instance.getUsername(forUID: post.senderId) { (returnedUserName) in
			cell.configureCell(profileImage: image!, email: returnedUserName, content: post.content, number: number )
		}
		
		if DataService.instance.verifyUrl(urlString: postArray[indexPath.row].postLink) {
            cell.LinkLbl.isHidden = false
        } else {
            cell.LinkLbl.isHidden = true
        }
		
		return cell
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		let cellLink = postArray[indexPath.row].postLink
		
        // If URL is valid open url, if not disable interaction
		if DataService.instance.verifyUrl(urlString: cellLink) == true {
            //TODO: add http:// to url paths in database
			let url = URL(string: cellLink )!
			
            UIApplication.shared.open(url, options: [:])
        } else {
			
            tableView.isUserInteractionEnabled = false
        }
		
        
    }
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// TODO: refactor into function that checks current user with message sender
		let currentUser = Auth.auth().currentUser!
		if (currentUser.uid == postArray[indexPath.row].senderId) {
			return true
		}
			return false
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			// handle delete (by removing the data from your array and updating the tableview
			
		
			let deletedPost = postArray[indexPath.row].postId
			let senderId = postArray[indexPath.row].senderId
			
			
			DataService.instance.deletePost(forUID: deletedPost, forSenderId: senderId, sendComplete: { (true) in
				print("deleted" + deletedPost)
				
			})
			self.postArray.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .bottom)
			self.tableView.reloadData()
		}
		
	}
}
