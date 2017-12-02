//
//  GroupPostViewController.swift
//  MAN_Tutors_iOS
//
//  Created by Manuel Thomsen on 23/11/2017.
//  Copyright © 2017 Manuel Thomsen. All rights reserved.
//

//TODO:Link label for tableViewCell is not displaying correctly.
//TODO: TableCells must be disabled if the URL is not valid

import UIKit
import Firebase

class GroupPostViewController: UIViewController {

	@IBOutlet weak var SendBtn: UIButton!
	@IBOutlet weak var BackBtn: UIButton!
	@IBOutlet weak var UsernameLbl: UILabel!
	@IBOutlet weak var postTextfield: UITextField!
	@IBOutlet weak var LinkTextfield: UITextField!
	@IBOutlet weak var LinkLbl: UILabel!
	
    var group: Group?
    var groupMessages = [Post]()
    
//    func initData(forGroup group: Group) {
//        self.group = group
//    }
    
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func SendBtnAction(_ sender: Any) {
        
        if postTextfield.text != "" {
                        SendBtn.isEnabled = true
                        //FIXME: missing withLink argument and missing texfield in group message
                        // TODO: check for valid url before uploading to DB to avoid multiple checks
            
            let postLink = self.LinkTextfield.text
            let url : String
            if DataService.instance.verifyUrl(urlString: postLink){
                
                url = "http://" + postLink!
            } else {
                 url = ""
            }
                DataService.instance.uploadPost(
                    withPost: postTextfield.text!,
                    forUID: Auth.auth().currentUser!.uid,
                    withgroupKey: group?.key,
                    withLink: url,
                    sendComplete: { (complete) in
                    if complete {
                        self.postTextfield.text = ""
                        self.postTextfield.isEnabled = true
                        self.SendBtn.isEnabled = false
                        self.dismiss(animated: true, completion: nil)
                            }
                        })
        } else {
            SendBtn.isEnabled = false
        }
        
        
    }
	
	
	
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
