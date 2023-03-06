//
//  ViewController.swift
//  UserDefaultsTests
//
//  Created by roberts.kursitis on 06/03/2023.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet private(set) var counterLabel: UILabel!
	@IBOutlet private(set) var incrementButton: UIButton!
	
	@IBAction private func incrementButtonTapped() {
		count += 1
	}
	
	private var count = 0 {
		didSet {
			counterLabel.text = "\(count)"
			UserDefaults.standard.set(count, forKey: "count")
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		count = UserDefaults.standard.integer(forKey: "count")
	}


}

