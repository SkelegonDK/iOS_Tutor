//
//  GroupPostViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 23/11/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

import UIKit

class GroupPostViewController: UIViewController {

	@IBOutlet weak var SendBtn: UIButton!
	@IBOutlet weak var BackBtn: UIButton!
	@IBOutlet weak var UsernameLbl: UILabel!
	@IBOutlet weak var postTextfield: PostTextView!
	@IBOutlet weak var LinkTextfield: UITextField!
	@IBOutlet weak var LinkLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func SendBtnAction(_ sender: Any) {
		
		
	}
	
	
	
	
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
