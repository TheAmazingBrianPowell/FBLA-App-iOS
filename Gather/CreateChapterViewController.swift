//
//  CreateChapterViewController.swift
//  Gather
//
//  Created by Brian Powell on 3/31/21.
//  Copyright © 2021 Brian Powell. All rights reserved.
//

import UIKit

class CreateChapterViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// only use the large size loading wheel if its available (iOS 13+)
		if #available(iOS 13.0, *) {
			load.style = .large
		}
	}
	@IBOutlet weak var chapterName: UITextField!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var load: UIActivityIndicatorView!
	
	@IBAction func create(_ sender: Any) {
		func createChapter (errors: String, output: String) {
			if errors != "" {
				self.errorText.text = errors
				self.load.stopAnimating()
			} else if output == "Verification error" {
				self.errorText.text = output
				self.load.stopAnimating()
			} else if output == "Success!" {
				self.load.stopAnimating()
				
				let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let homeView  = mainStoryBoard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
				
				homeView.modalPresentationStyle = .fullScreen
				
				self.present(homeView, animated: true, completion: nil)
			} else if output != "" {
				self.load.stopAnimating()
				self.errorText.text = output
			}
		}
		
		if chapterName.text! == "" {
			errorText.text = "Missing chapter name"
			return
		}
		
		load.startAnimating()
		Globals.request("/createChapter", input: "email=\(Globals.email)&pass=\(Globals.pass)&chapterName=\(chapterName.text!)", action: createChapter(errors: output:))
	}
}
