//
//  File.swift
//  Gather
//
//  Created by Brian Powell and Logan Bishop on 3/29/21.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

struct Globals {
	static let host = "https://fbla-app.herokuapp.com"
	static var email = ""
	static var name = ""
	static var pass = ""
	static var isAdvisor = 0
	static func request(_ directory:String, input:String, action: @escaping (String,String) -> Void) {
		var errors = ""
		var output = ""
		guard let requestUrl:URL = URL(string: Globals.host + directory) else {
			errors = "An error occurred. Please try again."
			return
		}
		
		let postString = input
		
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
			action(errors, output)
			if output != "" || errors != "" {
				timer.invalidate()
				return
			} else if timeOut > 200 {
				errors = "Network timeout. Please try again."
				timer.invalidate()
				return
			}
			timeOut+=1
		}
	}
}
