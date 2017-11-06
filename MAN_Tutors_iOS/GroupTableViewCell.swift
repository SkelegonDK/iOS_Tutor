//
//  GroupTableViewCell.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 10/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

	@IBOutlet weak var subjectLbl: UILabel!
	@IBOutlet weak var descriptionLbl: UILabel!
	@IBOutlet weak var membersLbl: UILabel!
	
	func configureCell(subject: String, description: String, members: Int ) {
		self.subjectLbl.text = subject
		self.descriptionLbl.text = description
		self.membersLbl.text = "\(members) members"
	}
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
