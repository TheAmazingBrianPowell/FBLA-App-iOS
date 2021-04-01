//
//  ReportBugViewController.swift
//  Gather
//
//  Created by Brian Powell and Logan Bishop on 3/31/21.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

class ReportBugViewController: UIViewController {

	@IBOutlet weak var textField: UITextView!
	@IBOutlet weak var load: UIActivityIndicatorView!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var successText: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// only use the large size loading wheel if its available (iOS 13+)
		if #available(iOS 13.0, *) {
			load.style = .large
		}
    }
	
	@IBAction func onReport(_ sender: UIButton) {
			func report (errors: String, output: String) {
				if errors != "" {
					self.errorText.text = errors
					self.load.stopAnimating()
				} else if output == "Verification error" {
					self.errorText.text = output
					self.load.stopAnimating()
				} else if output == "Success!" {
					self.load.stopAnimating()
					self.successText.text = "Your response has been recorded, thank you!"
				} else if output != "" {
					self.load.stopAnimating()
					self.errorText.text = output
				}
			}
			
			load.startAnimating()
			Globals.request("/report", input: "message=\(textField.text!)", action: report(errors: output:))
	}
	
}
