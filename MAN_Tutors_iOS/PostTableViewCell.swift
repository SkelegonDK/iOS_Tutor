//  PostTableViewCell.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 03/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
	

	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userEmail: UILabel!
	@IBOutlet weak var userContent: UILabel!
	@IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var LinkLbl: UILabel!
	@IBOutlet var LinkBtn: UIButton!
	
	
	func configureCell(profileImage: UIImage, email: String, content: String,number: String) {
		
		self.userImage.image = profileImage
		self.userEmail.text = email
		self.userContent.text = content
		self.userNumber.text = number
        self.LinkLbl.text = "Link available"
		
	}
	
}




