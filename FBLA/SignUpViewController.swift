//
//  SignUpViewController.swift
//  FBLA
//
//  Created by Brian Powell on 8/24/20.
//  Copyright © 2020 Brian Powell. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var pass: UITextField!
	@IBOutlet weak var verify: UITextField!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var load: UIActivityIndicatorView!
	@IBOutlet weak var name: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            load.style = .large
        }
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))

    }
	
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
	
	@IBAction func SignUp(_ sender: Any) {
		self.signUpButton.setTitle("Signing Up", for:.normal)
		load.startAnimating()
		errorText.text = ""
		var output:String?
		var errors:String?
		guard let requestUrl:URL = URL(string: "https://fbla-app.herokuapp.com/create") else {
			errorText.text = "An error occurred. Please try again."
			return
		}
		if verify.text! != pass.text! {
			errorText.text = "Passwords don't match!"
			load.stopAnimating()
			return
		}
		let postString = "name=\(name.text!)&email=\(email.text!)&pass=\(pass.text!)"
		
		var request = URLRequest(url: requestUrl)
		request.httpMethod = "POST"
		
		request.httpBody = postString.data(using: String.Encoding.utf8);

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
					
				// Check for Error
				if error != nil {
					errors = "An error occurred. Please try again."
					return
				}
			 
				// Convert HTTP Response Data to a String
				if let data = data, let dataString = String(data: data, encoding: .utf8) {
					output = dataString
					return
				}
		}
		task.resume()
		var timeOut:Int = 0
		Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
			if self.errorText.text != "" {
				self.signUpButton.setTitle("Sign Up", for:.normal)
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if errors != nil {
				self.errorText.text = errors
				self.signUpButton.setTitle("Sign Up", for:.normal)
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if output == "Success!" {
				self.signUpButton.setTitle("Sign Up", for:.normal)
				self.load.stopAnimating()
				print("Request took \(Double(timeOut)/10) seconds")
				timer.invalidate()
				print(output!)
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							
				let verifyView  = mainStoryBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
				verifyView.email = self.email.text!
				verifyView.pass = self.pass.text!
				verifyView.modalPresentationStyle = .fullScreen
				self.present(verifyView, animated: true, completion: nil)
				return
			} else if output != nil {
				self.signUpButton.setTitle("Sign Up", for:.normal)
				self.load.stopAnimating()
				self.errorText.text = output
				timer.invalidate()
				return
			} else if timeOut > 200 {
				self.signUpButton.setTitle("Sign Up", for:.normal)
				self.load.stopAnimating()
				self.errorText.text = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
	
	

}
