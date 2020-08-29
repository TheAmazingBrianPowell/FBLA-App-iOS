//
//  VerifyViewController.swift
//  FBLA
//
//  Created by Brian Powell on 8/27/20.
//  Copyright © 2020 Brian Powell. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
	@IBOutlet weak var load: UIActivityIndicatorView!
	@IBOutlet weak var errorText: UILabel!
	var email:String = ""
	var pass:String = ""
	@IBOutlet weak var verifyField: UITextField!
	@IBOutlet weak var successText: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            load.style = .large
        }
		view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
    }
	
	@IBAction func SignUp(_ sender: Any) {
		load.startAnimating()
		errorText.text = ""
		successText.text = ""
		var output:String?
		var errors:String?
		guard let requestUrl:URL = URL(string: "https://fbla-app.herokuapp.com/create") else {
			errorText.text = "An error occurred. Please try again."
			return
		}
		let postString = "email=\(email)&pass=\(pass)"
		
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
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if errors != nil {
				self.errorText.text = errors
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if output == "Success!" {
				self.load.stopAnimating()
				print("Request took \(Double(timeOut)/10) seconds")
				self.successText.text = "Success!"
				timer.invalidate()
				return
			} else if output != nil {
				self.load.stopAnimating()
				self.errorText.text = output
				timer.invalidate()
				return
			} else if timeOut > 200 {
				self.load.stopAnimating()
				self.errorText.text = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
	
	@IBAction func verifyFieldShouldReturn(_ sender: Any) {
		errorText.text = ""
		successText.text = ""
		load.startAnimating()
		var output:String?
		var errors:String?
		guard let requestUrl:URL = URL(string: "https://fbla-app.herokuapp.com/verify") else {
			errorText.text = "An error occurred. Please try again."
			return
		}
		
		let postString = "email=\(email)&pass=\(pass)&verify=\(verifyField.text!)"
		
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
				self.load.stopAnimating()
				timer.invalidate()
				return
			} else if errors != nil {
				self.load.stopAnimating()
				self.errorText.text = errors
				timer.invalidate()
				return
			} else if output == "Verification error" {
				self.load.stopAnimating()
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
				homeView.modalPresentationStyle = .fullScreen
				self.present(homeView, animated: true, completion: nil)
				timer.invalidate()
				return
			} else if output == "Success!" {
				self.load.stopAnimating()
				print("Request took \(timeOut/10) seconds")
				timer.invalidate()
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
				homeView.modalPresentationStyle = .fullScreen
				self.present(homeView, animated: true, completion: nil)
				return
			} else if output != nil {
				self.load.stopAnimating()
				self.errorText.text = output
				timer.invalidate()
			} else if timeOut > 200 {
				self.load.stopAnimating()
				self.errorText.text = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
	
	@IBAction func sendNewCode(_ sender: Any) {
		
	}
	
}
