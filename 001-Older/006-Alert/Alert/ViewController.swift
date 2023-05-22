//
//  ViewController.swift
//  Alert
//
//  Created by roberts.kursitis on 28/02/2023.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet private(set) var button: UIButton!
	@IBAction private func buttonTap() {
		let alert = UIAlertController(
			title: "Do the Thing?",
			message: "Let us know if you want to do this thing.",
			preferredStyle: .alert
		)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
			print(">> Cancel Tapped!")
		}
		let okAction = UIAlertAction(title: "OK", style: .default) { _ in
			print(">> OK Tapped!")
		}
		alert.addAction(cancelAction)
		alert.addAction(okAction)
		alert.preferredAction = okAction
		present(alert, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

