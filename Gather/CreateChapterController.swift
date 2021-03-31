//
//  CreateChapterController.swift
//  Gather
//
//  Created by Brian Powell and Logan Bishop on 3/30/21.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

class CreateChapterController: UITabBarController {

	var email:String = ""
	var pass:String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class CreateChapterViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	@IBOutlet weak var chapterName: UITextField!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var load: UIActivityIndicatorView!
	
	@IBAction func create(_ sender: UIButton) {
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
		Globals.request("/createChapter", input: "email=\(Globals.email)&pass=\(Globals.pass)", action: createChapter(errors: output:))
	}
}
