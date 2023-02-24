//
//  ViewController.swift
//  ButtonTapTests
//
//  Created by roberts.kursitis on 24/02/2023.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet private(set) var button: UIButton!
	@IBAction private func buttonTap() {
		print(">> Button was tapped!")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

