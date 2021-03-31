//
//  ViewController.swift
//  FBLA
//
//  Created by Brian Powell and Logan Bishop on 8/22/20.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

protocol UserData {
    func getUser(myData: String)
}


class ViewController: UIViewController {
	
	@IBOutlet weak var user: UITextField!
	@IBOutlet weak var pass: UITextField!
	@IBOutlet weak var logInButton: UIButton!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var load: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        if #available(iOS 13.0, *) {
            load.style = .large
        }
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
	}
	

	@IBAction func userFieldShouldReturn(_ sender: UITextField) {
		pass.becomeFirstResponder()
	}
	
	@IBAction func passFieldShouldReturn(_ sender: Any) {
		pass.resignFirstResponder()
		logInButton.setTitle("Logging In", for:.normal)
		load.startAnimating()
		errorText.text = ""
		
		func checkAction (errors: String, output: String) {
			if errors != "" {
				self.errorText.text = errors
				self.load.stopAnimating()
				self.logInButton.setTitle("Log In", for:.normal)
			} else if output == "Verification error" {
				self.errorText.text = output
				self.load.stopAnimating()
				self.logInButton.setTitle("Log In", for:.normal)
			} else if output == "Success!" {
				self.load.stopAnimating()
				self.logInButton.setTitle("Log In", for:.normal)
				
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
				Globals.email = user.text!
				Globals.pass = pass.text!
				homeView.modalPresentationStyle = .fullScreen
				
				self.present(homeView, animated: true, completion: nil)
			} else if output != "" {
				self.load.stopAnimating()
				self.errorText.text = output
				self.logInButton.setTitle("Log In", for:.normal)
			}
		}
		Globals.request("/check", input: "email=\(user.text!)&pass=\(pass.text!)", action: checkAction(errors: output:))
	}
}
