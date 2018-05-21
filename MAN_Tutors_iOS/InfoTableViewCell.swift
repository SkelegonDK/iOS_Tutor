//
//  InfoTableViewCell.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 18/12/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import WebKit

class InfoTableViewCell: UITableViewCell {
	
	@IBOutlet var webView: WKWebView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
    }
	
	func configureCell(content: String) {
		
		self.webView.loadHTMLString(content, baseURL: nil)
		self.webView.scrollView.isScrollEnabled = false;
		self.webView.scrollView.bounces = false;
	}

}

