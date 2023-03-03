//
//  SegueNextViewController.swift
//  Navigation
//
//  Created by roberts.kursitis on 02/03/2023.
//

import UIKit

class SegueNextViewController: UIViewController {
	
	var labelText: String?
	
	@IBOutlet private(set) var label: UILabel!
	
	deinit {
		print(">> SegueNextViewController.deinit")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		label.text = labelText
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
