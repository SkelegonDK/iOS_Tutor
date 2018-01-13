//
//  SecondViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

	@IBOutlet weak var groupsTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
			groupsTableView.delegate = self
			groupsTableView.dataSource = self
			groupsTableView.tableFooterView = UIView()
	}
	
	var groupsArray = [Group]()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		DataService.instance.GROUPS_REF.observe(.value, with: { (snapshot) in
//			DataService.instance.getAllGroups { (returnedGroupArray) in
//				self.groupsArray = returnedGroupArray.reversed()
//				self.groupsTableView.reloadData()
//			}
//			
//		})
		
	}
	@IBAction func backBtnAction(_ sender: Any) {
		dismiss(animated: true, completion: nil)
 
	}
	

	
}
extension GroupViewController: UITableViewDelegate,UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groupsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell else {return UITableViewCell() }
		
		let group = groupsArray[indexPath.row]
		
		cell.configureCell(subject:"</" + group.groupTitle + ">", description: group.groupDesc, members: group.memberCount)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let groupFeedViewController = storyboard?.instantiateViewController(withIdentifier: "GroupFeedViewController") as? GroupFeedViewController else {return}
		groupFeedViewController.initData(forGroup: groupsArray[indexPath.row])
		present(groupFeedViewController, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 100
	}
	
}

