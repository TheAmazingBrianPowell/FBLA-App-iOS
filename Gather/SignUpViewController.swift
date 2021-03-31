//
//  SignUpViewController.swift
//  FBLA
//
//  Created by Brian Powell and Logan Bishop on 8/24/20.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

	// link inputs and outputs from view controller
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var pass: UITextField!
	@IBOutlet weak var verify: UITextField!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var load: UIActivityIndicatorView!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var isAdvisor: UISegmentedControl!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// only use the large size loading wheel if its available (iOS 13+)
        if #available(iOS 13.0, *) {
            load.style = .large
        }
		
		// allows for user to exit focus on an input
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))

    }
	
	// function is called when the next or done button on the keyboard is pressed
	@IBAction func fieldsShouldReturn(_ sender: UITextField) {
		if sender == name {
			email.becomeFirstResponder()
		} else if sender == email {
			pass.becomeFirstResponder()
		} else if sender == pass {
			verify.becomeFirstResponder()
		} else {
			verify.resignFirstResponder()
		}
	}
	
	// called when the sign up button is selected or when the last text field selects the done button
	@IBAction func SignUp(_ sender: Any) {
		self.signUpButton.setTitle("Signing Up", for:.normal)
		load.startAnimating()
		errorText.text = ""
		
		if verify.text! != pass.text! {
			errorText.text = "Passwords don't match!"
			load.stopAnimating()
			return
		}
		
		func signUpAction (errors: String, output: String) {
			if errors != "" {
				self.errorText.text = errors
				self.load.stopAnimating()
				self.signUpButton.setTitle("Sign Up", for:.normal)
			} else if output == "Success!" {
				self.load.stopAnimating()
				
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let verifyView  = mainStoryBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
				
				Globals.email = self.email.text!
				Globals.pass = self.pass.text!
				Globals.name = self.name.text!
				Globals.isAdvisor = self.isAdvisor.selectedSegmentIndex
				verifyView.modalPresentationStyle = .fullScreen
				
				self.present(verifyView, animated: true, completion: nil)
			} else if output != "" {
				self.load.stopAnimating()
				self.errorText.text = output
				self.signUpButton.setTitle("Sign Up", for:.normal)
			}
		}
		Globals.request("/create", input: "name=\(name.text!)&email=\(email.text!)&pass=\(pass.text!)&isAdvisor=\(isAdvisor.selectedSegmentIndex)", action: signUpAction(errors: output:))
	}
}
