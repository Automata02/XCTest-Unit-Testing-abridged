//
//  ClosurePropertyViewController.swift
//  HardDependencies
//
//  Created by roberts.kursitis on 23/02/2023.
//

import UIKit

class ClosurePropertyViewController: UIViewController {
	var makeAnalytics: () -> Analytics = { Analytics.shared }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		makeAnalytics().track(event: "viewDidAppear - \(type(of: self))")
	}
}
