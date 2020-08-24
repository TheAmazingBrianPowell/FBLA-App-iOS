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
	@IBOutlet weak var user: UITextField!
	@IBOutlet weak var pass: UITextField!
	@IBOutlet weak var errorText: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))

    }
	
	@IBAction func fieldsShouldReturn(_ sender: UITextField) {
		if sender == email {
			user.becomeFirstResponder()
		} else if sender == user {
			pass.becomeFirstResponder()
		} else {
			pass.resignFirstResponder()
		}
	}
	
	@IBAction func SignUp(_ sender: Any) {
		var output:String?
		var errors:String?
		guard let requestUrl:URL = URL(string: "https://fbla-app.herokuapp.com") else {
			errorText.text = "An error occurred. Please try again."
			return
		}
		
		let postString = "email=\(email.text!)&name=\(user.text!)&pass=\(pass.text!)"
		
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
				timer.invalidate()
				return
			} else if errors != nil {
				self.errorText.text = errors
				timer.invalidate()
				return
			} else if output != nil {
				print("Request took \(timeOut/10) seconds")
				timer.invalidate()
				print(output!)
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
				homeView.modalPresentationStyle = .fullScreen
				self.present(homeView, animated: true, completion: nil)
				return
			} else if(timeOut > 200) {
				self.errorText.text = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
	
	

}
