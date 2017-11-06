//
//  ViewShadow.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 02/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class ViewShadow: UIView {

	override func awakeFromNib() {
		self.layer.cornerRadius = 3
		self.layer.shadowOpacity = 0.5
		self.layer.shadowRadius = 3
		self.layer.shadowColor = UIColor.black.cgColor
		super.awakeFromNib()
		
	}
}
