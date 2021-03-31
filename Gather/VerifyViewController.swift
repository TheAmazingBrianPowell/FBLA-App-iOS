//
//  VerifyViewController.swift
//  FBLA
//
//  Created by Brian Powell and Logan Bishop on 8/27/20.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
	@IBOutlet weak var load: UIActivityIndicatorView!
	@IBOutlet weak var errorText: UILabel!
	var isAdvisor:Int = 0
	@IBOutlet weak var verifyField: UITextField!
	@IBOutlet weak var successText: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            load.style = .large
        }
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
    }
	
	@IBAction func verifyFieldShouldReturn(_ sender: Any) {
		errorText.text = ""
		successText.text = ""
		load.startAnimating()
		
		func verifyAction (errors: String, output: String) {

			if errors != "" {
				self.errorText.text = errors
				self.load.stopAnimating()
			} else if output == "Success!" {
				self.load.stopAnimating()
				
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "CreateChapterController") as! CreateChapterController
				
				homeView.modalPresentationStyle = .fullScreen
				
				self.present(homeView, animated: true, completion: nil)
			} else if output != "" {
				self.load.stopAnimating()
				self.errorText.text = output
			}
		}
		Globals.request("/verify", input: "email=\(Globals.email)&pass=\(Globals.pass)&verify=\(verifyField.text!)", action: verifyAction(errors: output:))
	}
	
	@IBAction func sendNewCode(_ sender: Any) {
			load.startAnimating()
			errorText.text = ""
			successText.text = ""
		
		func resendAction (errors: String, output: String) {

			if errors != "" {
				self.errorText.text = errors
				self.load.stopAnimating()
			} else if output == "Success!" {
				self.load.stopAnimating()
				self.successText.text = "Success!"
			} else if output != "" {
				self.load.stopAnimating()
				self.errorText.text = output
			}
		}
		Globals.request("/create", input: "email=\(Globals.email)&pass=\(Globals.pass)&name=\(Globals.name)&isAdvisor=\(isAdvisor)", action: resendAction(errors: output:))
	}
	
}
