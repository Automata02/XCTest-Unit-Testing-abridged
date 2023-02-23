//
//  MySingletonAnalytics.swift
//  HardDependencies
//
//  Created by roberts.kursitis on 21/02/2023.
//

import Foundation

// If a test provides a stubbedInstance the shared property returns the stubbed one instead of the singleton.

class MySingletonAnalytics {
	private static let instance = MySingletonAnalytics()
	
	#if DEBUG
	static var stubbedInstance: MySingletonAnalytics?
	#endif
	
	static var shared: MySingletonAnalytics {
		#if DEBUG
		if let stubbedInstance = stubbedInstance {
			return stubbedInstance
		}
		#endif
		
		return instance
	}
	
	func track(event: String) {
		Analytics.shared.track(event: event)
		
		if self !== MySingletonAnalytics.instance {
			print(">> Not the MySingletonAnalytics singleton")
		}
	}
}
