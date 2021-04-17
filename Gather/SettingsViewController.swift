//
//  SettingsViewController.swift
//  Gather
//
//  Created by Brian Powell and Logan Bishop on 3/31/21.
//  Copyright © 2021 Brian Powell and Logan Bishop. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

	@IBOutlet weak var name: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		name.text = Globals.name
    }
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 5
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 5
	}
	
	
	
	override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		if #available(iOS 13.0, *) {
			(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemBackground
		}
//		let border = UIView(frame: CGRect(x: self.view.layoutMargins.left,y: 5,width: self.view.bounds.width - self.view.layoutMargins.left,height: 1))
//		border.backgroundColor = UIColor.lightGray
//		if #available(iOS 13.0, *) {
//			border.backgroundColor = UIColor.opaqueSeparator
//		} else {
//			border.backgroundColor = UIColor.lightGray
//		}
//
//		if section != 0 {
//			(view as! UITableViewHeaderFooterView).contentView.addSubview(border)
//		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let border1 = UIView(frame: CGRect(x: self.view.layoutMargins.left,y: 5,width: self.view.bounds.width - self.view.layoutMargins.left,height: 1))
		let border2 = UIView(frame: CGRect(x: self.view.layoutMargins.left,y: self.view.bounds.height - 1,width: self.view.bounds.width - self.view.layoutMargins.left,height: 1))
		cell.contentView.addSubview(border1)
		cell.contentView.addSubview(border2)
	}
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if #available(iOS 13.0, *) {
			(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemBackground
		}
//		let border = UIView(frame: CGRect(x: self.view.layoutMargins.left,y: self.view.bounds.height - 1,width: self.view.bounds.width - self.view.layoutMargins.left,height: 1))
//		if #available(iOS 13.0, *) {
//			border.backgroundColor = UIColor.opaqueSeparator
//		} else {
//			border.backgroundColor = UIColor.lightGray
//		}
//
//		if section != 0 {
//			(view as! UITableViewHeaderFooterView).contentView.addSubview(border)
//		}
	}
	
	@IBAction func onLogout(_ sender: Any) {
		Globals.email = ""
		Globals.pass = ""
		Globals.name = ""
		Globals.isAdvisor = 0
	}
}
