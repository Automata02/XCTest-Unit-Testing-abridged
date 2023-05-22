//
//  ClosureInitializerViewController.swift
//  HardDependencies
//
//  Created by roberts.kursitis on 23/02/2023.
//

import UIKit

class ClosureInitializerViewController: UIViewController {
	private let makeAnalytics: () -> Analytics
	
	//@escaping because it needs to store it in the property
	init(makeAnalytics: @escaping () -> Analytics = { Analytics.shared } ) {
		self.makeAnalytics = makeAnalytics
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		makeAnalytics().track(event: "viewDidAppear - \(type(of: self))")
	}
}
