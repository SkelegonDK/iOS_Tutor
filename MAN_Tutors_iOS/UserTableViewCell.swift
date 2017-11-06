//
//  UserTableViewCell.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 03/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	@IBOutlet weak var addLbl: UILabel!
	
	var wasSelected: Bool = false
	let darkYellow :UIColor = UIColor(red: 0.553, green: 0.522, blue: 0.043, alpha: 1)
	
	
	func configureCell(userImage image: UIImage, email: String, isSelected: Bool) {
		self.userImage.image = image
		self.userNameLbl.text = email
		
		
		if isSelected {
			self.addLbl.text = "</remove>"
			
		} else {
			
			self.addLbl.text = "</add>"
			
		}
	}
	// ** debug selector view **
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		if selected {
			if wasSelected == false {
				self.addLbl.text = "</remove>"
				self.addLbl.textColor = UIColor.red
				wasSelected = true
			
			} else {
				self.addLbl.text = "</add>"
				self.addLbl.textColor = darkYellow
				wasSelected = false
			}
			
		}
	}
}
