//
//  Analytics.swift
//  HardDependencies
//
//  Created by roberts.kursitis on 21/02/2023.
//

import Foundation

class Analytics {
	static let shared = Analytics()
	
	func track(event: String) {
		print(">> " + event)
		
		if self !== Analytics.shared {
			print(">> ...Not the Analytics singleton")
		}
	}
}
