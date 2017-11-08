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
		
		
		
		DataService.instance.getFeedData { (returnedPostsArray) in
		
//			self.postArray = returnedPostsArray.reversed()
			self.postArray = returnedPostsArray
			self.tableView.reloadData()
			
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
//		let number = "You are number " + String(postArray.count - indexPath.row) + " in line"
		let number = "You are number " + String(indexPath.row + 1) + " in line"
		
		
//			cell.configureCell(profileImage: image!, email: post.senderId, content: post.content)
		
			DataService.instance.getUsername(forUID: post.senderId) { (returnedUserName) in
			cell.configureCell(profileImage: image!, email: returnedUserName, content: post.content, number: number )
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			// handle delete (by removing the data from your array and updating the tableview
			
			//TODO: delete tableview cell from database by getting post id and delete child
			//TODO: Deleting from Firebase and reloading the table should be enough!
			let deletedPost = postArray[indexPath.row].content
//            DataService.deletePost(deletedPost)
            
			postArray.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .bottom)
			self.tableView.reloadData()
			
		}
	}
	
}
