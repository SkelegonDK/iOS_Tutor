//
//  InfoViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 18/12/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit
import Firebase
import WebKit

class InfoViewController: UIViewController, WKNavigationDelegate {
	

	@IBOutlet var WebView: WKWebView!
	
	var infoArray = [String]()
	
	
    override func viewDidLoad() {
		WebView.navigationDelegate = self
        super.viewDidLoad()
		self.WebView.scrollView.isScrollEnabled = true
		self.WebView.scrollView.bounces = true
		self.WebView.isOpaque = false
		
		
		DataService.instance.INFO_REF.observe(.value) { (DataSnapshot) in
			DataService.instance.getInfoData { (infoArray) in
				self.infoArray = infoArray
				let headStart = "<!DOCTYPE html><html><head><meta charset='utf-8' name='viewport' content='width=device-width,initial-scale=1,user-scalable=no'><title>INFOTEST</title>"
				let style = "<style media='screen'>body {min-height: 150px;font-family: helvetica;background-color:#EDE011; display:flex; justify-content:center; flex-direction:column;} body>div{min-height:100px; padding-bottom:30px;} .button {border-radius: 5px;background-color: #8D850B;border-color: red;width: 200px; height: 50px;color: #ffffff;font-size: 18px;display: flex;flex-direction: row;justify-content: center;align-items: center;}a {text-decoration: none;color:#ffffff;}</style>"
				let headEnd = "</head><body>"
				let bodyEnd = "</body></html>"
				let content = headStart + style + headEnd + infoArray.joined() + bodyEnd
				
				self.WebView.loadHTMLString(content, baseURL: nil)
				self.WebView.fadeIn()

				
			}
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.navigationType == .linkActivated  {
			if let url = navigationAction.request.url,
				let host = url.host, !host.hasPrefix("www.google.com"),
				UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url)
				print(url)
				print("Redirected to browser. No need to open it locally")
				decisionHandler(.cancel)
			} else {
				print("Open it locally")
				decisionHandler(.allow)
			}
		} else {
			print("not a user click")
			decisionHandler(.allow)
		}
	}
	
	
}



