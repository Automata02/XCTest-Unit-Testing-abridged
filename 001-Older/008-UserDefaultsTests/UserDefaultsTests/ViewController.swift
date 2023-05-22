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
	
	var userDefaults: UserDefaultsProtocol = UserDefaults.standard
	
	private var count = 0 {
		didSet {
			counterLabel.text = "\(count)"
			userDefaults.set(count, forKey: "count")
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		count = userDefaults.integer(forKey: "count")
	}
}


protocol UserDefaultsProtocol {
	func set(_ value: Int, forKey defaultName: String)
	func integer(forKey defaultName: String) -> Int
}

extension UserDefaults: UserDefaultsProtocol {}
