//
//  ViewController.swift
//  FBLA
//
//  Created by Brian Powell on 8/22/20.
//  Copyright © 2020 Brian Powell. All rights reserved.
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
		
		
		var output:String?
		var errors:String?
		guard let requestUrl:URL = URL(string: "https://fbla-app.herokuapp.com/check") else {
			errorText.text = "An error occurred. Please try again."
			return
		}
		
		let postString = "email=\(user.text!)&pass=\(pass.text!)"
		
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
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if errors != nil {
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				self.errorText.text = errors
				timer.invalidate()
				return
			} else if output == "Verification error" {
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let verifyView  = mainStoryBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
				verifyView.modalPresentationStyle = .fullScreen
				verifyView.email = self.user.text!
				verifyView.pass = self.pass.text!
				self.present(verifyView, animated: true, completion: nil)
				timer.invalidate()
				return
			} else if output == "Success!" {
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				print("Request took \(timeOut/10) seconds")
				timer.invalidate()
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
				homeView.modalPresentationStyle = .fullScreen
				self.present(homeView, animated: true, completion: nil)
				return
			} else if output != nil {
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				self.errorText.text = output
				timer.invalidate()
			} else if timeOut > 200 {
				self.logInButton.setTitle("Log In", for:.normal)
				self.load.stopAnimating()
				self.errorText.text = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
}
