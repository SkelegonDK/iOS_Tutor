//
//  postClass.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 03/09/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import Foundation

class Post {
	private var _content: String
	private var _senderId: String
	
	var content: String {
		return _content
	}
	
	var senderId: String {
		return _senderId
	}
	
	init(content: String, senderId: String) {
		self._content = content
		self._senderId = senderId
	}
	
	
}
