//
//  GroupFeedCell.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 10/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

	class GroupFeedCell: UITableViewCell {

		@IBOutlet weak var profileImage: UIImageView!
		@IBOutlet weak var emailLbl: UILabel!
		@IBOutlet weak var contentLbl: UILabel!
		
		func configureCell(profileImage: UIImage, email: String, content: String) {
			self.profileImage.image = profileImage
			self.emailLbl.text = email
			self.contentLbl.text = content
		}
	}

