//
//  InstancePropertyViewController.swift
//  HardDependencies
//
//  Created by roberts.kursitis on 23/02/2023.
//

import UIKit

class InstancePropertyViewController: UIViewController {
	
	lazy var analytics = Analytics.shared
	//declared as lazy it has no initial value

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		analytics.track(event: "viewDidAppear - \(type(of: self))")
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
