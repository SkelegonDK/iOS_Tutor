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
	private var _postId: String
	private var _postLink: String
	
	
	
	var content: String {
		return _content
	}
	
	var senderId: String {
		return _senderId
	}
	var postId: String {
		return _postId
	}
	var postLink: String {
		return _postLink
	}
	
	init(content: String, senderId: String, postId: String, postLink: String) {
		self._content = content
		self._senderId = senderId
		self._postId = postId
		self._postLink = postLink
	}
	
	
}
