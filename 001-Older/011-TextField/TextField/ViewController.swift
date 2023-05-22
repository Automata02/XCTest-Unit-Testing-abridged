//
//  ViewController.swift
//  TextField
//
//  Created by roberts.kursitis on 15/03/2023.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet private(set) var usernameField: UITextField!
	@IBOutlet private(set) var passwordField: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	deinit {
		print("ViewController.deinit")
	}
	
	//prevents user from entering spaces in to the textfield
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool { if textField === usernameField {
		return !string.contains(" ") } else {
			return true
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === usernameField {
			passwordField.becomeFirstResponder()
		} else {
			guard let username = usernameField.text, let password = passwordField.text else {
				return false
			}
			passwordField.resignFirstResponder()
			performLogin(username: username, password: password)
		}
		return true
	}
	
	func performLogin(username: String, password: String) {
		print("Username: \(username)")
		print("Password: \(password)")
	}
}

